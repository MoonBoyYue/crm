package com.crm.dao;

import com.crm.bean.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User userLogin(@Param("username")String username,@Param("password")String password);

    void insertUserMsg(@Param("username")String username,@Param("password")String password);

    List<User> selectUsers();
}
