package com.crm.listener;

import com.crm.bean.DicValue;
import com.crm.service.DicService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebListener
public class jedisListen implements ServletContextListener {
    /*监听器注解注入对象行不通，监听器init执行时spring容器并未被创建
    @Resource
    private DicService dicService;*/

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        //获取全局域对象
        ServletContext application = servletContextEvent.getServletContext();

        //获取service对象
        DicService dicService = (DicService) WebApplicationContextUtils.getWebApplicationContext(application).getBean(DicService.class);

        /*业务层拿取数据字典
        * map
        * { "dataType的code",{data中code对应的所有数据集合} }
        * */
        Map<String, List<DicValue>> all = dicService.getAll();
        //获取所有的key
        Set<String> codes = all.keySet();
        //遍历所有key拿到对应的数据集合，再存入全局域
        for(String key:codes){
            application.setAttribute(key,all.get(key));
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
