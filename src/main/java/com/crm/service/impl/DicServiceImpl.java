package com.crm.service.impl;

import com.crm.bean.DicType;
import com.crm.bean.DicValue;
import com.crm.dao.DicTypeDao;
import com.crm.dao.DicValueDao;
import com.crm.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {

    @Resource
    private DicTypeDao typeDao;
    @Resource
    private DicValueDao valueDao;

    @Override
    public Map<String, List<DicValue>> getAll() {

        Map<String, List<DicValue>> map = new HashMap<>();

        //将字典类型表取出
        List<DicType> type = typeDao.selectTypes();
        //根据每个type区查询对应的数据value
        for(DicType typ: type){
            //查询对应的数据详细数据,并存入map
            String code = typ.getCode();
            List<DicValue> dicValues= valueDao.getText(code);
            map.put(code,dicValues);
        }
        return map;
    }
}
