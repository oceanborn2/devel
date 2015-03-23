package ews.client;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java pour engineOutput complex type.
 * 
 * <p>Le fragment de sch�ma suivant indique le contenu attendu figurant dans cette classe.
 * 
 * <pre>
 * &lt;complexType name="engineOutput">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="fileHeader" type="{urn:hpexstream-services/Engine}header" minOccurs="0"/>
 *         &lt;element name="fileName" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="fileOutput" type="{http://www.w3.org/2001/XMLSchema}base64Binary" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "engineOutput", propOrder = {
    "fileHeader",
    "fileName",
    "fileOutput"
})
public class EngineOutput {

    protected Header fileHeader;
    protected String fileName;
    protected byte[] fileOutput;

    /**
     * Obtient la valeur de la propri�t� fileHeader.
     * 
     * @return
     *     possible object is
     *     {@link Header }
     *     
     */
    public Header getFileHeader() {
        return fileHeader;
    }

    /**
     * D�finit la valeur de la propri�t� fileHeader.
     * 
     * @param value
     *     allowed object is
     *     {@link Header }
     *     
     */
    public void setFileHeader(Header value) {
        this.fileHeader = value;
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

    /**
     * Obtient la valeur de la propri�t� fileOutput.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getFileOutput() {
        return fileOutput;
    }

    /**
     * D�finit la valeur de la propri�t� fileOutput.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setFileOutput(byte[] value) {
        this.fileOutput = value;
    }

}
