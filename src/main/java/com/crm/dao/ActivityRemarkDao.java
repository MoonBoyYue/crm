package com.crm.dao;

import com.crm.bean.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int selectCount(String[] id);

    int delete(String[] id);

    List<ActivityRemark> getRemark(String activityId);

    int deleteRemark(String id);

    int addRemark(ActivityRemark ar);

    int editRemark(ActivityRemark remark);
}
