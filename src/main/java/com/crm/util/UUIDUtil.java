package com.crm.util;

import java.util.UUID;

public class UUIDUtil {
    public static String getUUID(){
        //返回一个32位的随机串（全球唯一）--> eff23dd4-e3de-4a9a-a95f-39a2ec3178b4 (共36位)
        return UUID.randomUUID().toString().replace("-","");
    }
}
