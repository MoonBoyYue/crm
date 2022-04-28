package com.crm.controller;

import com.crm.bean.Clue;
import com.crm.bean.User;
import com.crm.service.ClueService;
import com.crm.util.DataTimeUtil;
import com.crm.util.UUIDUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/clue")
public class ClueController {
    @Resource
    private ClueService clueService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> getUsers(){
        List<User> users = clueService.getUsers();
        return users;
    }

    @RequestMapping("/save.do")
    @ResponseBody
    public boolean save(HttpServletRequest request, Clue clue){
        String uuid = UUIDUtil.getUUID();
        String createTime = DataTimeUtil.getSysTime();
        User user = (User) request.getSession().getAttribute("user");
        String name = user.getName();
        clue.setCreateBy(name);
        clue.setCreateTime(createTime);
        clue.setId(uuid);
        boolean flag=true;
        int i = clueService.save(clue);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){
        Clue clue=clueService.getUserById(id);
        ModelAndView mv = new ModelAndView();
        mv.addObject("detailClue",clue);
        mv.setViewName("/workbench/clue/detail.jsp");
        return mv;
    }
}
