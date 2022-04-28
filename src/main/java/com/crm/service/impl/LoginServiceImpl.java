package com.crm.service.impl;

import com.crm.bean.User;
import com.crm.dao.UserDao;
import com.crm.service.LoginService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Service
public class LoginServiceImpl implements LoginService {
    @Resource
    private UserDao userDao;


    @Override
    public User login(String username, String password) {
        User user = userDao.userLogin(username, password);
        return user;
    }
}
