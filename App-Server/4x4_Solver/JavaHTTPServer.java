import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;
import java.util.StringTokenizer;
import java.io.StringReader;
import java.util.Hashtable;

// The tutorial can be found just here on the SSaurel's Blog : 
// https://www.ssaurel.com/blog/create-a-simple-http-web-server-in-java
// Each Client Connection will be managed in a dedicated Thread
public class JavaHTTPServer implements Runnable{ 
	
	// port to listen connection
	static final int PORT = 4000;
	
	// verbose mode
	static final boolean verbose = true;
	
	// Client Connection via Socket Class
	private Socket socket;
	
	public JavaHTTPServer(Socket c) {
		socket = c;
	}
	
	public static void main(String[] args) {
		try {
			ServerSocket serverConnect = new ServerSocket(PORT);
			System.out.println("Server started.\nListening for connections on port : " + PORT + " ...\n");
			
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
		String fileRequested = null;
		
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
            System.out.println(parser.getMessageBody());
		    
		    
		    
		    
			
			
//			// get first line of the request from the client
//			String input = in.readLine();
//			// we parse the request with a string tokenizer
//			StringTokenizer parse = new StringTokenizer(input);
//			String method = parse.nextToken().toUpperCase(); // we get the HTTP method of the client
//			// we get file requested
//			fileRequested = parse.nextToken().toLowerCase();
//			
//			// we support only GET and HEAD methods, we check
//			if (!method.equals("GET")  &&  !method.equals("HEAD")) {
//				if (verbose) {
//					System.out.println("501 Not Implemented : " + method + " method.");
//				}
//				
//				// we return the not supported file to the client
//				File file = new File(WEB_ROOT, METHOD_NOT_SUPPORTED);
//				int fileLength = (int) file.length();
//				String contentMimeType = "text/html";
//				//read content to return to client
//				byte[] fileData = readFileData(file, fileLength);
//					
//				// we send HTTP Headers with data to client
//				out.println("HTTP/1.1 501 Not Implemented");
//				out.println("Server: Java HTTP Server from SSaurel : 1.0");
//				out.println("Date: " + new Date());
//				out.println("Content-type: " + contentMimeType);
//				out.println("Content-length: " + fileLength);
//				out.println(); // blank line between headers and content, very important !
//				out.flush(); // flush character output stream buffer
//				// file
//				dataOut.write(fileData, 0, fileLength);
//				dataOut.flush();
//				
//			} else {
//				// GET or HEAD method
//				if (fileRequested.endsWith("/")) {
//					fileRequested += DEFAULT_FILE;
//				}
//				
//				File file = new File(WEB_ROOT, fileRequested);
//				int fileLength = (int) file.length();
//				String content = getContentType(fileRequested);
//				
//				if (method.equals("GET")) { // GET method so we return content
//					byte[] fileData = readFileData(file, fileLength);
//					
//					// send HTTP Headers
//					out.println("HTTP/1.1 200 OK");
//					out.println("Server: Java HTTP Server from SSaurel : 1.0");
//					out.println("Date: " + new Date());
//					out.println("Content-type: " + content);
//					out.println("Content-length: " + fileLength);
//					out.println(); // blank line between headers and content, very important !
//					out.flush(); // flush character output stream buffer
//					
//					dataOut.write(fileData, 0, fileLength);
//					dataOut.flush();
//				}
//				
//				if (verbose) {
//					System.out.println("File " + fileRequested + " of type " + content + " returned");
//				}
//				
//			}
			
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
	
	// return supported MIME Types
	private String getContentType(String fileRequested) {
		if (fileRequested.endsWith(".htm")  ||  fileRequested.endsWith(".html"))
			return "text/html";
		else
			return "text/plain";
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

        String header = reader.readLine();
        while (header.length() > 0) {
            appendHeaderParameter(header);
            header = reader.readLine();
        }

        while(reader.ready()){
            String bodyLine = reader.readLine().trim();
            appendMessageBody(bodyLine);
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
            throw new HttpFormatException("Invalid Header Parameter: " + header);
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

	/**
	 * 
	 */
	private static final long	serialVersionUID	= 1L;

	public HttpFormatException(String arg0)
    {
	    super(arg0);
    }
	
}
