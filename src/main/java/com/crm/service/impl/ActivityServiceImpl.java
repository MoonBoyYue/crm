package com.crm.service.impl;

import com.crm.bean.Activity;
import com.crm.bean.ActivityRemark;
import com.crm.bean.User;
import com.crm.dao.ActivityDao;
import com.crm.dao.ActivityRemarkDao;
import com.crm.dao.UserDao;
import com.crm.service.ActivityService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private UserDao userDao;
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ActivityRemarkDao remarkDao;

    @Override
    public List<User> findActivity() {
        List<User> userList = userDao.selectUsers();

        return userList;
    }


    @Override
    public int insertActivity(Activity activity) {
        int i = activityDao.insertActivity(activity);
        return i;
    }

    @Override
    public List<Activity> searchActivity(Map map) {
        List<Activity> allList = activityDao.findAll(map);
        return allList;
    }

    @Override
    public int countActivity(Map map) {
        int i =activityDao.countActivity(map);
        return i;
    }

    @Override
    public boolean delete(String[] id) {
        //删除前看删除项是否关联市场活动备注表，先删除备注表在删除市场活动
        boolean flag=true;
        //查询市场备注表应该删除的数据个数
        int remarkCount1 = remarkDao.selectCount(id);

        //删除备注
        int remarkCount2 = remarkDao.delete(id);

        if(remarkCount1!=remarkCount2){
            flag=false;
        }

        //删除市场活动
        int i = activityDao.deletActivity(id);
        if(id.length!=i){
            flag=false;
        }
        return flag;
    }

    @Override
    public Activity getActivity(String id) {
        Activity activity=activityDao.getActivity(id);
        return activity;
    }

    @Override
    public boolean updateActivity(Activity activity) {
        int i = activityDao.updateAcyivity(activity);
        boolean flag=true;
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity activity = activityDao.getDetailActivity(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> getRemark(String activityId) {
        List<ActivityRemark> remarks = remarkDao.getRemark(activityId);
        return remarks;
    }

    @Override
    public int deleteRemark(String id) {
        int i = remarkDao.deleteRemark(id);
        return i;
    }

    @Override
    public int addRemark(ActivityRemark ar) {
        int i=remarkDao.addRemark(ar);
        return i;
    }

    @Override
    public int editRemark(ActivityRemark remark) {
        int i=remarkDao.editRemark(remark);
        return i;
    }
}
