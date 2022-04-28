package com.crm.service.impl;

import com.crm.bean.Clue;
import com.crm.bean.User;
import com.crm.dao.ClueDao;
import com.crm.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueDao clueDao;

    @Override
    public List<User> getUsers() {
        List<User> users=clueDao.getUsers();
        return users;
    }

    @Override
    public int save(Clue clue) {
        int i=clueDao.save(clue);
        return i;
    }

    @Override
    public Clue getUserById(String id) {
        Clue clue=clueDao.getUserById(id);
        return clue;
    }
}
