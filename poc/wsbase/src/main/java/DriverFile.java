
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java pour driverFile complex type.
 * 
 * <p>Le fragment de sch�ma suivant indique le contenu attendu figurant dans cette classe.
 * 
 * <pre>
 * &lt;complexType name="driverFile">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="driver" type="{http://www.w3.org/2001/XMLSchema}base64Binary" minOccurs="0"/>
 *         &lt;element name="fileName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "driverFile", propOrder = {
    "driver",
    "fileName"
})
public class DriverFile {

    protected byte[] driver;
    protected String fileName;

    /**
     * Obtient la valeur de la propri�t� driver.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getDriver() {
        return driver;
    }

    /**
     * D�finit la valeur de la propri�t� driver.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setDriver(byte[] value) {
        this.driver = value;
    }

    /**
     * Obtient la valeur de la propri�t� fileName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFileName() {
        return fileName;
    }

    /**
     * D�finit la valeur de la propri�t� fileName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFileName(String value) {
        this.fileName = value;
    }

}
