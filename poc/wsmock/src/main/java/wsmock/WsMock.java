package wsmock;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.xml.ws.Endpoint;
import java.util.HashMap;

@WebService()
public class WsMock {

    @WebMethod
    public String ping() {
        return "pong";
    }

    @WebMethod
    public MockResponse
    compose(HashMap<String, String> requestParameters) {
        MockResponse res = new MockResponse();
        return res;
    }


    public static void main(String[] argv) {
        Object implementor = new WsMock();
        String address = "http://localhost:8080/WsMock";
        Endpoint.publish(address, implementor);
    }

}
