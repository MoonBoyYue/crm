package com.crm.controller;

import com.crm.bean.Activity;
import com.crm.bean.ActivityRemark;
import com.crm.bean.User;
import com.crm.service.ActivityService;
import com.crm.util.DataTimeUtil;
import com.crm.util.UUIDUtil;
import com.crm.vo.PageListVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/activity")
public class ActivityController {
    @Resource
    private ActivityService activityService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> findUserActivity(){
        List<User> activity = activityService.findActivity();
        return activity;
    }

    /*@Resource
    private Activity activity;*/

    @RequestMapping("/insertAcyivity.do")
    @ResponseBody
    public <activity> Map<String,Object> insertActivity(HttpServletRequest request,Activity activity){
        String uuid = UUIDUtil.getUUID();
        String creatTime = DataTimeUtil.getSysTime();//创建时间
        String createBy = ((User) request.getSession().getAttribute("user")).getName();//创建人
        activity.setId(uuid);
        activity.setCreateTime(creatTime);
        activity.setCreateBy(createBy);

        /*System.out.println("------开始插入");*/
        //System.out.println(request.getQueryString());
        /*System.out.println(activity);*/
        int i = activityService.insertActivity(activity);
       /* System.out.println("------插入完成");*/

        Map<String,Object> map=new HashMap<>();
        Boolean flag=true;
        if(i!=1){
            flag=false;
        }
        map.put("success",flag);
        return map;
    }

    @RequestMapping("/searchActivity.do")
    @ResponseBody
    public PageListVO<Activity> searchActivity (@RequestParam("pageNo")int pageNo,
                                      @RequestParam("pageSize")int pageSize,
                                      Activity activity){
        //略过记录数
        int pageSkip=(pageNo-1)*pageSize;
        Map map=new HashMap();
        map.put("pageSkip",pageSkip);
        map.put("pageSize",pageSize);
        map.put("owner",activity.getOwner());
        map.put("name",activity.getName());
        map.put("startDate",activity.getStartDate());
        map.put("endDate",activity.getEndDate());
        //拿到Activity集合 和 总记录条数
        List<Activity> activityList = activityService.searchActivity(map);
       int size =activityService.countActivity(map);

        PageListVO<Activity> vo = new PageListVO<>();
        vo.setTotal(size);
        vo.setDataList(activityList);
        return vo;
    }

    @RequestMapping("/delete.do")
    @ResponseBody
    public Map deleteActivity(HttpServletRequest request){
        String[] ids = request.getParameterValues("id");
        boolean delete = activityService.delete(ids);

        Map map=new HashMap();
        map.put("success",delete);
        return map;
    }

    @RequestMapping("/getUserActivity.do")
    @ResponseBody
    public Map getUserActivity(String id){
        //获取user集合
        List<User> userList = activityService.findActivity();
        //获取activity集合
        Activity activity = activityService.getActivity(id);

        Map map=new HashMap();
        map.put("userList",userList);
        map.put("activity",activity);

        System.out.println(activity);

        return map;
    }

    @RequestMapping("updateActivity.do")
    @ResponseBody
    public boolean updateActivity(HttpServletRequest request,Activity activity){
        //创建编辑时间
        String sysTime = DataTimeUtil.getSysTime();
        //获取编辑人
        User user = (User) request.getSession().getAttribute("user");
        String name = user.getName();

        activity.setEditTime(sysTime);
        activity.setEditBy(name);

        System.out.println(activity);
        //修改市场活动
        boolean success = activityService.updateActivity(activity);
        return success;
    }

    @RequestMapping("/detail.do")
    public void detail(HttpServletRequest request,HttpServletResponse response,String id) throws ServletException, IOException {
        Activity detailActivity = activityService.detail(id);
        request.getSession().setAttribute("detailActivity",detailActivity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    @RequestMapping("/getActivityRemark.do")
    @ResponseBody
    public List<ActivityRemark> getActivityRemark(String activityId){
        List<ActivityRemark> remarks = activityService.getRemark(activityId);
        return remarks;
    }

    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    public boolean deleteRemark(String id){
        boolean flag=true;
        int i = activityService.deleteRemark(id);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @RequestMapping("/addRemark.do")
    @ResponseBody
    public Map addRemark(HttpServletRequest request,String noteContent,String activityId){
        ActivityRemark ar = new ActivityRemark();
        String id = UUIDUtil.getUUID();
        String createTime = DataTimeUtil.getSysTime();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String editFlag="0";

        ar.setId(id);
        ar.setNoteContent(noteContent);
        ar.setActivityId(activityId);
        ar.setCreateTime(createTime);
        ar.setCreateBy(createBy);
        ar.setEditFlag(editFlag);

        boolean flag=true;
        int i=activityService.addRemark(ar);
        if(i!=1){
            flag=false;
        }
        Map map=new HashMap();
        map.put("success",flag);
        map.put("ar",ar);
        return map;
    }

    @RequestMapping("/editRemark.do")
    @ResponseBody
    public Map editRemark(HttpServletRequest request,ActivityRemark remark){

        String editTime = DataTimeUtil.getSysTime();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        remark.setEditTime(editTime);
        remark.setEditBy(editBy);
        remark.setEditFlag("1");
        int i=activityService.editRemark(remark);

        boolean flag=true;
        if (i!=1){
            flag=false;
        }

        Map map = new HashMap();
        map.put("success",flag);
        map.put("ar",remark);

        return map;
    }
}
