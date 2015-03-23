package security.encryption;

import javax.crypto.*;
import javax.crypto.spec.IvParameterSpec;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public class AES256EncryptionScheme extends EncryptionScheme {

    public final String AES256 = "AES256";
    public final String AES_CBC_PKCS5 = "AES/CBC/PKCS5Padding";

    public AES256EncryptionScheme() {
        super("AES256");
    }

    //String FileName = "encryptedtext.txt";
    //String FileName2 = "decryptedtext.txt";
//    Files.write(Paths.get(FileName), byteCipherText);
    //byte[] cipherText = Files.readAllBytes(Paths.get(FileName));
    //Files.write(Paths.get(FileName2), bytePlainText);

    public IvParameterSpec generateIV() {
        byte[] iv = new byte[16];
        SecureRandom random = new SecureRandom();
        random.nextBytes(iv);
        return new IvParameterSpec(iv);
    }

    public SecretKey generateSecretKey() throws NoSuchAlgorithmException {
        KeyGenerator KeyGen = KeyGenerator.getInstance("AES");
        KeyGen.init(128);
        return KeyGen.generateKey();
    }


    @Override
    public byte[] encrypt(byte[] content, SecretKey secKey, byte[] iv) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
        Cipher AesCipher = Cipher.getInstance(AES_CBC_PKCS5); //Cipher AesCipher = Cipher.getInstance("AES");
        AesCipher.init(Cipher.ENCRYPT_MODE, secKey);
        byte[] byteCipherText = AesCipher.doFinal(content);
        return byteCipherText;
    }

    @Override
    public byte[] decrypt(byte[] cipherText, SecretKey SecKey, byte[] iv) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
        Cipher AesCipher = Cipher.getInstance(AES_CBC_PKCS5); //Cipher AesCipher = Cipher.getInstance("AES");
        AesCipher.init(Cipher.DECRYPT_MODE, SecKey);
        byte[] bytePlainText = AesCipher.doFinal(cipherText);
        return bytePlainText;
    }
}
