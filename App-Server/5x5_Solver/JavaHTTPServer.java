import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;
import java.util.Hashtable;
import cs.cube555.Search;
import cs.cube555.Tools;
import cs.cube555.CubieCube;
import java.util.*;


// Each Client Connection will be managed in a dedicated Thread
public class JavaHTTPServer implements Runnable{ 
	
	// port to listen connection
	static final int PORT = 4010;
	
	// verbose mode
	static final boolean verbose = true;
	
	// Client Connection via Socket Class
    private Socket socket;

	HashMap<String, Integer> move2Int;

	public JavaHTTPServer(Socket c) {
		socket = c;

		String[] move_str = new String[] {
		    "U", "U2", "U'", "R", "R2", "R'", "F", "F2", "F'",
		    "D", "D2", "D'", "L", "L2", "L'", "B", "B2", "B'",
		    "u", "u2", "u'", "r", "r2", "r'", "f", "f2", "f'",
		    "d", "d2", "d'", "l", "l2", "l'", "b", "b2", "b'"
		};

		move2Int = new HashMap<String, Integer>();
		for(int i=0;i<move_str.length;i++){
			move2Int.put(move_str[i], i);
		}
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

            Search.init();
			Search search = new Search();
			cs.min2phase.Search search333 = new cs.min2phase.Search();

			CubieCube cube = new CubieCube();
			// System.out.println(cube);

			int[] moves = convert_moves_to_int(scrambleMoves.split("\\s+"));
			cube.doCornerMove(moves);
			cube.doMove(moves);

			String facelet = cube.toFacelet();
			System.out.println(facelet);
			String[] solution = search.solveReduction(facelet, 0);
			System.out.println(solution[0] + " --- " + solution[1]);

			String solution333 = search333.solution(solution[1], 21, Integer.MAX_VALUE, 500, 0);
			System.out.println(solution333);

			String solutionMoves = solution[0] + " " + solution333;

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

	int[] convert_moves_to_int(String[] moves){
		int[] c_moves = new int[moves.length];
		int c_moves_ptr = 0;

		try{
			for(String move : moves){
				c_moves[c_moves_ptr] = move2Int.get(move);
				c_moves_ptr++;
			}
		}catch(Exception e){
			System.out.println("Unknown move "+ Arrays.toString(moves));
			// return a already solved cube, 0=>U  2=>U'
			return new int[]{0, 2};
		}
		return c_moves;
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
