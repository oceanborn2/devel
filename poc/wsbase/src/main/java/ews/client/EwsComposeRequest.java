package ews.client;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java pour ewsComposeRequest complex type.
 * 
 * <p>Le fragment de sch�ma suivant indique le contenu attendu figurant dans cette classe.
 * 
 * <pre>
 * &lt;complexType name="ewsComposeRequest">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="driver" type="{urn:hpexstream-services/Engine}driverFile" minOccurs="0"/>
 *         &lt;element name="driverEncoding" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="engineOptions" type="{urn:hpexstream-services/Engine}engineOption" maxOccurs="unbounded" minOccurs="0"/>
 *         &lt;element name="fileReturnRegEx" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="includeHeader" type="{http://www.w3.org/2001/XMLSchema}boolean"/>
 *         &lt;element name="includeMessageFile" type="{http://www.w3.org/2001/XMLSchema}boolean"/>
 *         &lt;element name="outputFile" type="{urn:hpexstream-services/Engine}output" minOccurs="0"/>
 *         &lt;element name="pubFile" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="pubFiles" type="{urn:hpexstream-services/Engine}pubFiles" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ewsComposeRequest", propOrder = {
    "driver",
    "driverEncoding",
    "engineOptions",
    "fileReturnRegEx",
    "includeHeader",
    "includeMessageFile",
    "outputFile",
    "pubFile",
    "pubFiles"
})
public class EwsComposeRequest {

    protected DriverFile driver;
    protected String driverEncoding;
    @XmlElement(nillable = true)
    protected List<EngineOption> engineOptions;
    protected String fileReturnRegEx;
    protected boolean includeHeader;
    protected boolean includeMessageFile;
    protected Output outputFile;
    protected String pubFile;
    protected PubFiles pubFiles;

    /**
     * Obtient la valeur de la propri�t� driver.
     * 
     * @return
     *     possible object is
     *     {@link DriverFile }
     *     
     */
    public DriverFile getDriver() {
        return driver;
    }

    /**
     * D�finit la valeur de la propri�t� driver.
     * 
     * @param value
     *     allowed object is
     *     {@link ews.client.DriverFile }
     *     
     */
    public void setDriver(DriverFile value) {
        this.driver = value;
    }

    /**
     * Obtient la valeur de la propri�t� driverEncoding.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDriverEncoding() {
        return driverEncoding;
    }

    /**
     * D�finit la valeur de la propri�t� driverEncoding.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDriverEncoding(String value) {
        this.driverEncoding = value;
    }

    /**
     * Gets the value of the engineOptions property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the engineOptions property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getEngineOptions().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link EngineOption }
     * 
     * 
     */
    public List<EngineOption> getEngineOptions() {
        if (engineOptions == null) {
            engineOptions = new ArrayList<EngineOption>();
        }
        return this.engineOptions;
    }

    /**
     * Obtient la valeur de la propri�t� fileReturnRegEx.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFileReturnRegEx() {
        return fileReturnRegEx;
    }

    /**
     * D�finit la valeur de la propri�t� fileReturnRegEx.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFileReturnRegEx(String value) {
        this.fileReturnRegEx = value;
    }

    /**
     * Obtient la valeur de la propri�t� includeHeader.
     * 
     */
    public boolean isIncludeHeader() {
        return includeHeader;
    }

    /**
     * D�finit la valeur de la propri�t� includeHeader.
     * 
     */
    public void setIncludeHeader(boolean value) {
        this.includeHeader = value;
    }

    /**
     * Obtient la valeur de la propri�t� includeMessageFile.
     * 
     */
    public boolean isIncludeMessageFile() {
        return includeMessageFile;
    }

    /**
     * D�finit la valeur de la propri�t� includeMessageFile.
     * 
     */
    public void setIncludeMessageFile(boolean value) {
        this.includeMessageFile = value;
    }

    /**
     * Obtient la valeur de la propri�t� outputFile.
     * 
     * @return
     *     possible object is
     *     {@link Output }
     *     
     */
    public Output getOutputFile() {
        return outputFile;
    }

    /**
     * D�finit la valeur de la propri�t� outputFile.
     * 
     * @param value
     *     allowed object is
     *     {@link Output }
     *     
     */
    public void setOutputFile(Output value) {
        this.outputFile = value;
    }

    /**
     * Obtient la valeur de la propri�t� pubFile.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPubFile() {
        return pubFile;
    }

    /**
     * D�finit la valeur de la propri�t� pubFile.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPubFile(String value) {
        this.pubFile = value;
    }

    /**
     * Obtient la valeur de la propri�t� pubFiles.
     * 
     * @return
     *     possible object is
     *     {@link PubFiles }
     *     
     */
    public PubFiles getPubFiles() {
        return pubFiles;
    }

    /**
     * D�finit la valeur de la propri�t� pubFiles.
     * 
     * @param value
     *     allowed object is
     *     {@link PubFiles }
     *     
     */
    public void setPubFiles(PubFiles value) {
        this.pubFiles = value;
    }

}
