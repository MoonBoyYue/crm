package com.crm.service;

import com.crm.bean.Activity;
import com.crm.bean.ActivityRemark;
import com.crm.bean.User;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    //获取user集合
    List<User> findActivity();
    //增加市场活动
    int insertActivity(Activity activity);
    //分页：activity集合
    List<Activity> searchActivity(Map map);
    //分页：总记录数
    int countActivity(Map map);
    //删除集合中所有id的市场活动
    boolean delete(String[] id);
    //获取指定id市场活动
    Activity getActivity(String id);
    //更新市场活动，返回boolean
    boolean updateActivity(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemark(String activityId);

    int deleteRemark(String id);

    int addRemark(ActivityRemark ar);

    int editRemark(ActivityRemark remark);
}
