package com.crm.controller;

import com.crm.bean.User;
import com.crm.service.LoginService;
import com.crm.util.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class LoginController {
    @Resource
    private LoginService loginService;
    
    @RequestMapping("/login.do")
    @ResponseBody
    public Map<String,Object> userLogin(String username,String password,HttpServletRequest request) {

        /*String md5 = MD5Util.getMD5(password);*/
        String msg;
        Boolean flag;
        User login = loginService.login(username,password);
        //保存到session域
        request.getSession().setAttribute("user",login);
        ModelAndView mv = new ModelAndView();
        if(login!=null){
            msg="登录成功";
            flag=true;
            /*mv.setViewName("/workbench/index.jsp");*/
        }else {
            msg="账号密码错误";
            flag=false;
        }
        Map<String, Object> map = new HashMap<>();
        map.put("msg",msg);
        map.put("success",flag);
        return map;
    }
}
