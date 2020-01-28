import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;
import java.util.Hashtable;
import cs.threephase.Search;


// Each Client Connection will be managed in a dedicated Thread
public class JavaHTTPServer implements Runnable{ 
	
	// port to listen connection
	static final int PORT = 4000;
	
	// verbose mode
	static final boolean verbose = true;
	
	// Client Connection via Socket Class
    private Socket socket;
    
    private static Search search = new Search();
	
	public JavaHTTPServer(Socket c) {
		socket = c;
	}
	
	public static void main(String[] args) {
		try {
			ServerSocket serverConnect = new ServerSocket(PORT);
			System.out.println("Server started.\nListening for connections on port : " + PORT + " ...");
			
			// we listen until user halts server execution
			while (true) {
				JavaHTTPServer myServer = new JavaHTTPServer(serverConnect.accept());
				
				if (verbose) {
					System.out.println("Connecton opened. (" + new Date() + ")");
				}
				
				// create dedicated thread to manage the client connection
				Thread thread = new Thread(myServer);
				thread.start();
			}
			
		} catch (IOException e) {
			System.err.println("Server Connection error : " + e.getMessage());
		}
	}

	@Override
	public void run() {
		// we manage our particular client connection
		BufferedReader in = null; PrintWriter out = null; BufferedOutputStream dataOut = null;
		try {
			// we read characters from the client via input stream on the socket
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			// we get character output stream to client (for headers)
			out = new PrintWriter(socket.getOutputStream());
			// get binary output stream to client (for requested data)
			dataOut = new BufferedOutputStream(socket.getOutputStream());
			            
            		    
		    HttpRequestParser parser = new HttpRequestParser();
            parser.parseRequest(in);


            // System.out.println(parser.getRequestLine());
            System.out.println(parser.getRequestLine());

            String[] tmp = parser.getRequestLine().split("\\s+");
            String GETParam = tmp[1].substring(2);
            String scrambleMoves = GETParam.split("=")[1];
            scrambleMoves = scrambleMoves.replaceAll("_", " ");

            System.out.println(scrambleMoves);

            String solutionMoves = search.solve(scrambleMoves);
            System.out.println(solutionMoves);
            
            
            // CREATE RESPONSE

            // send HTTP Headers
            String contentType = "text/plain";
            String messageLength = String.valueOf(solutionMoves.length()+1);
            out.println("HTTP/1.1 200 OK");
            out.println("Server: Java HTTP Server from SSaurel : 1.0");
            out.println("Date: " + new Date());
            out.println("Content-type: " + contentType);
            out.println("Content-length: " + messageLength);
            out.println(); // blank line between headers and content, very important !
            out.println(solutionMoves);
            out.flush();
			
			
		} catch ( Exception e ){
			System.out.println("Server error : " + e);
		}finally {
			try {
				in.close();
				out.close();
				dataOut.close();
				socket.close(); // we close socket connection
			} catch (Exception e) {
				System.err.println("Error closing stream : " + e.getMessage());
			} 
			
			if (verbose) {
				System.out.println("Connection closed.\n");
			}
		}
	}	
}


/**
 * Class for HTTP request parsing as defined by RFC 2612:
 * 
 * Request = Request-Line ; Section 5.1 (( general-header ; Section 4.5 |
 * request-header ; Section 5.3 | entity-header ) CRLF) ; Section 7.1 CRLF [
 * message-body ] ; Section 4.3
 * 
 * @author izelaya
 *
 */
class HttpRequestParser {

    private String _requestLine;
    private Hashtable<String, String> _requestHeaders;
    private StringBuffer _messagetBody;

    public HttpRequestParser() {
        _requestHeaders = new Hashtable<String, String>();
        _messagetBody = new StringBuffer();
    }

    /**
     * Parse and HTTP request.
     * 
     * @param request
     *            String holding http request.
     * @throws IOException
     *             If an I/O error occurs reading the input stream.
     * @throws HttpFormatException
     *             If HTTP Request is malformed
     */
    public void parseRequest(BufferedReader reader) throws IOException, HttpFormatException {
        setRequestLine(reader.readLine()); // Request-Line ; Section 5.1
        
        String header = "";
        while(reader.ready()){
            char c  = (char)reader.read();
            if(c=='\n' || c== -1){
                // System.out.println("header --> "+ header);
                appendHeaderParameter(header);
                header = "";
            }else{
                header += c;
            }
            
        } 
    }

    /**
     * 
     * 5.1 Request-Line The Request-Line begins with a method token, followed by
     * the Request-URI and the protocol version, and ending with CRLF. The
     * elements are separated by SP characters. No CR or LF is allowed except in
     * the final CRLF sequence.
     * 
     * @return String with Request-Line
     */
    public String getRequestLine() {
        return _requestLine;
    }
    

    private void setRequestLine(String requestLine) throws HttpFormatException {
        if (requestLine == null || requestLine.length() == 0) {
            throw new HttpFormatException("Invalid Request-Line: " + requestLine);
        }
        _requestLine = requestLine;
    }

    private void appendHeaderParameter(String header) throws HttpFormatException {
        int idx = header.indexOf(":");
        if (idx == -1) {
            return;
            // throw new HttpFormatException("Invalid Header Parameter: " + header);
        }
        // System.out.println(String.format("%s %s", header.substring(0, idx), header.substring(idx + 1, header.length())));
        _requestHeaders.put(header.substring(0, idx), header.substring(idx + 1, header.length()));
    }

    /**
     * The message-body (if any) of an HTTP message is used to carry the
     * entity-body associated with the request or response. The message-body
     * differs from the entity-body only when a transfer-coding has been
     * applied, as indicated by the Transfer-Encoding header field (section
     * 14.41).
     * @return String with message-body
     */
    public String getMessageBody() {
        return _messagetBody.toString();
    }

    private void appendMessageBody(String bodyLine) {
        _messagetBody.append(bodyLine).append("\r\n");
    }

    /**
     * For list of available headers refer to sections: 4.5, 5.3, 7.1 of RFC 2616
     * @param headerName Name of header
     * @return String with the value of the header or null if not found.
     */
    public String getHeaderParam(String headerName){
        return _requestHeaders.get(headerName);
    }
}

class HttpFormatException extends Exception
{
	private static final long serialVersionUID	= 1L;

	public HttpFormatException(String arg0)
    {
	    super(arg0);
    }
	
}
