package com.crm.vo;

import java.util.List;

public class PageListVO<T> {
    private  Integer total;
   private  List<T> dataList;

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }
}
