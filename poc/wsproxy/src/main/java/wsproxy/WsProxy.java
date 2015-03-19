package wsproxy;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.xml.ws.Endpoint;
import java.util.HashMap;

@WebService
public class WsProxy {

    public static void main(String[] argv) {
        Object implementor = new WsProxy();
        String address = "http://localhost:8080/services/WsProxy";
        Endpoint.publish(address, implementor);
    }

    @WebMethod
    public String ping() {
        return "pong";
    }

    @WebMethod
    public byte[] compose(HashMap<String, String> requestParameters) {
        return null;
    }

}
