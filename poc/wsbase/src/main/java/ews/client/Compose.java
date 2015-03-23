package ews.client;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java pour ews.client.Compose complex type.
 * 
 * <p>Le fragment de sch�ma suivant indique le contenu attendu figurant dans cette classe.
 * 
 * <pre>
 * &lt;complexType name="ews.client.Compose">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="EWSComposeRequest" type="{urn:hpexstream-services/Engine}ewsComposeRequest" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Compose", propOrder = {
    "ewsComposeRequest"
})
public class Compose {

    @XmlElement(name = "EWSComposeRequest")
    protected EwsComposeRequest ewsComposeRequest;

    /**
     * Obtient la valeur de la propri�t� ewsComposeRequest.
     * 
     * @return
     *     possible object is
     *     {@link EwsComposeRequest }
     *     
     */
    public EwsComposeRequest getEWSComposeRequest() {
        return ewsComposeRequest;
    }

    /**
     * D�finit la valeur de la propri�t� ewsComposeRequest.
     * 
     * @param value
     *     allowed object is
     *     {@link EwsComposeRequest }
     *     
     */
    public void setEWSComposeRequest(EwsComposeRequest value) {
        this.ewsComposeRequest = value;
    }

}
