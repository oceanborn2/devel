package wsmock;

import java.io.*;

public class MockResponse {

    public MockResponse() {

    }

    public byte[] getResponse() throws IOException {
        File pdfDoc = new File("ED012011.pdf");
        Long fsize = pdfDoc.length();
        BufferedInputStream bis = new BufferedInputStream(new FileInputStream(pdfDoc));
        byte[] pdfBuf = new byte[fsize.intValue()];
        int bsize = bis.read(pdfBuf);
        assert(bsize == fsize);
        return "PDF-1.7%".getBytes();
    }

    public void setResponse(byte[] response) {
        this.response = response;
    }

    byte[] response;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    String url;
}
