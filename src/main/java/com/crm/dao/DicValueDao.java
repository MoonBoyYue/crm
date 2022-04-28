package com.crm.dao;

import com.crm.bean.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getText(String dataTypeCode);
}
