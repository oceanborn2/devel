package ews.client;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java pour header complex type.
 * 
 * <p>Le fragment de sch�ma suivant indique le contenu attendu figurant dans cette classe.
 * 
 * <pre>
 * &lt;complexType name="header">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="DDAOutputFile" type="{http://www.w3.org/2001/XMLSchema}boolean"/>
 *         &lt;element name="defaultExtension" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="fileType" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="messageLength" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="outputLength" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="PDL" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="pageCount" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="returnCode" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="userData" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="userDataLength" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *         &lt;element name="version" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "header", propOrder = {
    "ddaOutputFile",
    "defaultExtension",
    "fileType",
    "messageLength",
    "outputLength",
    "pdl",
    "pageCount",
    "returnCode",
    "userData",
    "userDataLength",
    "version"
})
public class Header {

    @XmlElement(name = "DDAOutputFile")
    protected boolean ddaOutputFile;
    protected String defaultExtension;
    protected String fileType;
    protected int messageLength;
    protected int outputLength;
    @XmlElement(name = "PDL")
    protected int pdl;
    protected int pageCount;
    protected int returnCode;
    protected String userData;
    protected int userDataLength;
    protected int version;

    /**
     * Obtient la valeur de la propri�t� ddaOutputFile.
     * 
     */
    public boolean isDDAOutputFile() {
        return ddaOutputFile;
    }

    /**
     * D�finit la valeur de la propri�t� ddaOutputFile.
     * 
     */
    public void setDDAOutputFile(boolean value) {
        this.ddaOutputFile = value;
    }

    /**
     * Obtient la valeur de la propri�t� defaultExtension.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDefaultExtension() {
        return defaultExtension;
    }

    /**
     * D�finit la valeur de la propri�t� defaultExtension.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDefaultExtension(String value) {
        this.defaultExtension = value;
    }

    /**
     * Obtient la valeur de la propri�t� fileType.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFileType() {
        return fileType;
    }

    /**
     * D�finit la valeur de la propri�t� fileType.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFileType(String value) {
        this.fileType = value;
    }

    /**
     * Obtient la valeur de la propri�t� messageLength.
     * 
     */
    public int getMessageLength() {
        return messageLength;
    }

    /**
     * D�finit la valeur de la propri�t� messageLength.
     * 
     */
    public void setMessageLength(int value) {
        this.messageLength = value;
    }

    /**
     * Obtient la valeur de la propri�t� outputLength.
     * 
     */
    public int getOutputLength() {
        return outputLength;
    }

    /**
     * D�finit la valeur de la propri�t� outputLength.
     * 
     */
    public void setOutputLength(int value) {
        this.outputLength = value;
    }

    /**
     * Obtient la valeur de la propri�t� pdl.
     * 
     */
    public int getPDL() {
        return pdl;
    }

    /**
     * D�finit la valeur de la propri�t� pdl.
     * 
     */
    public void setPDL(int value) {
        this.pdl = value;
    }

    /**
     * Obtient la valeur de la propri�t� pageCount.
     * 
     */
    public int getPageCount() {
        return pageCount;
    }

    /**
     * D�finit la valeur de la propri�t� pageCount.
     * 
     */
    public void setPageCount(int value) {
        this.pageCount = value;
    }

    /**
     * Obtient la valeur de la propri�t� returnCode.
     * 
     */
    public int getReturnCode() {
        return returnCode;
    }

    /**
     * D�finit la valeur de la propri�t� returnCode.
     * 
     */
    public void setReturnCode(int value) {
        this.returnCode = value;
    }

    /**
     * Obtient la valeur de la propri�t� userData.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUserData() {
        return userData;
    }

    /**
     * D�finit la valeur de la propri�t� userData.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUserData(String value) {
        this.userData = value;
    }

    /**
     * Obtient la valeur de la propri�t� userDataLength.
     * 
     */
    public int getUserDataLength() {
        return userDataLength;
    }

    /**
     * D�finit la valeur de la propri�t� userDataLength.
     * 
     */
    public void setUserDataLength(int value) {
        this.userDataLength = value;
    }

    /**
     * Obtient la valeur de la propri�t� version.
     * 
     */
    public int getVersion() {
        return version;
    }

    /**
     * D�finit la valeur de la propri�t� version.
     * 
     */
    public void setVersion(int value) {
        this.version = value;
    }

}
