package com.crm.dao;

import com.crm.bean.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    //添加市场活动
    int insertActivity(Activity activity);
    //分页：获取所有市场活动
    List<Activity> findAll(Map map);
    //分页：获取所有市场活动总数量
    int countActivity(Map map);
    //删除市场活动
    int deletActivity(String[] id);
    //获取指定id的市场活动
    Activity getActivity(String id);
    //修改对应id的市场活动
    int updateAcyivity(Activity activity);
    //获取对应id的市场活动信息，owner为t_user表的name
    Activity getDetailActivity(String id);
}
