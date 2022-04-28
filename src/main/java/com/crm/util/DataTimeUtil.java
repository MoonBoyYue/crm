package com.crm.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DataTimeUtil {
    public static String getSysTime(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        String sysTime = sdf.format(date);
        return sysTime;
    }
}
