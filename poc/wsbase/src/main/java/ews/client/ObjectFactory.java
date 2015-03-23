package ews.client;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the wsproxy package. 
 * <p>An ews.client.ObjectFactory allows you to programatically
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _Compose_QNAME = new QName("urn:hpexstream-services/Engine", "ews.client.Compose");
    private final static QName _ComposeResponse_QNAME = new QName("urn:hpexstream-services/Engine", "ews.client.ComposeResponse");
    private final static QName _EngineServiceException_QNAME = new QName("urn:hpexstream-services/Engine", "ews.client.EngineServiceException");

    /**
     * Create a new ews.client.ObjectFactory that can be used to create new instances of schema derived classes for package: wsproxy
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link Compose }
     * 
     */
    public Compose createCompose() {
        return new Compose();
    }

    /**
     * Create an instance of {@link ComposeResponse }
     * 
     */
    public ComposeResponse createComposeResponse() {
        return new ComposeResponse();
    }

    /**
     * Create an instance of {@link EngineServiceException }
     * 
     */
    public EngineServiceException createEngineServiceException() {
        return new EngineServiceException();
    }

    /**
     * Create an instance of {@link Output }
     * 
     */
    public Output createOutput() {
        return new Output();
    }

    /**
     * Create an instance of {@link ews.client.DriverFile }
     * 
     */
    public DriverFile createDriverFile() {
        return new DriverFile();
    }

    /**
     * Create an instance of {@link EngineOutput }
     * 
     */
    public EngineOutput createEngineOutput() {
        return new EngineOutput();
    }

    /**
     * Create an instance of {@link EngineOption }
     * 
     */
    public EngineOption createEngineOption() {
        return new EngineOption();
    }

    /**
     * Create an instance of {@link PubFiles }
     * 
     */
    public PubFiles createPubFiles() {
        return new PubFiles();
    }

    /**
     * Create an instance of {@link Header }
     * 
     */
    public Header createHeader() {
        return new Header();
    }

    /**
     * Create an instance of {@link EwsComposeRequest }
     * 
     */
    public EwsComposeRequest createEwsComposeRequest() {
        return new EwsComposeRequest();
    }

    /**
     * Create an instance of {@link EwsComposeResponse }
     * 
     */
    public EwsComposeResponse createEwsComposeResponse() {
        return new EwsComposeResponse();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Compose }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "urn:hpexstream-services/Engine", name = "ews.client.Compose")
    public JAXBElement<Compose> createCompose(Compose value) {
        return new JAXBElement<Compose>(_Compose_QNAME, Compose.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ComposeResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "urn:hpexstream-services/Engine", name = "ews.client.ComposeResponse")
    public JAXBElement<ComposeResponse> createComposeResponse(ComposeResponse value) {
        return new JAXBElement<ComposeResponse>(_ComposeResponse_QNAME, ComposeResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link EngineServiceException }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "urn:hpexstream-services/Engine", name = "ews.client.EngineServiceException")
    public JAXBElement<EngineServiceException> createEngineServiceException(EngineServiceException value) {
        return new JAXBElement<EngineServiceException>(_EngineServiceException_QNAME, EngineServiceException.class, null, value);
    }

}
