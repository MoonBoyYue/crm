package com.crm.service;

import com.crm.bean.User;

import javax.jws.soap.SOAPBinding;
import java.util.List;
import java.util.Map;

public interface LoginService {
    User login(String username, String password);
}
