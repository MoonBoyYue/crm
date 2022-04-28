package com.crm.dao;

import com.crm.bean.Clue;
import com.crm.bean.User;

import java.util.List;

public interface ClueDao {

    List<User> getUsers();

    int save(Clue clue);

    Clue getUserById(String id);
}
