package wsmock;

import javax.jws.WebMethod;
import javax.jws.WebService;
import java.util.HashMap;

@WebService()
public class WsMock /*implements EngineWebService */{

    @WebMethod
    public MockResponse compose(HashMap<String, String> requestParameters) {
        MockResponse res = new MockResponse();
        return res;
    }

}
