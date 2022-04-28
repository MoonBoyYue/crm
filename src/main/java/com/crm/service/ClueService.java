package com.crm.service;

import com.crm.bean.Clue;
import com.crm.bean.User;

import java.util.List;

public interface ClueService {
    //获取所有用户
    List<User> getUsers();

    int save(Clue clue);

    Clue getUserById(String id);
}
