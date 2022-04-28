package com.crm.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Util {
    public static String getMD5(String string){
        //得到一个信息摘要器
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance(string);
            byte[] digest = md5.digest();
            StringBuffer stringBuffer = new StringBuffer();
            //把每一个byte做一个信息运算 0xff;
            for (byte b:digest){
                //与运算
                int number =b & 0xff;//加盐
                String str =Integer.toHexString(number);
                if(str.length()==1){
                    stringBuffer.append("0");
                }
                stringBuffer.append(str);
            }
            //标准的md5加密后的结果
            return  stringBuffer.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return "";
        }
    }
}
