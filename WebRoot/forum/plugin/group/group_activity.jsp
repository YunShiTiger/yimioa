﻿<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%
	long id = ParamUtil.getLong(request, "id");
	GroupDb gd = new GroupDb();
	gd = (GroupDb) gd.getQObjectDb(new Long(id));
	if (gd == null) {
		return;
	}

	UserMgr um = new UserMgr();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
	<HEAD id=Head1>
		<TITLE><%=gd.getString("name")%> - <%=Global.AppName%></TITLE>
		<META http-equiv=Content-Type content="text/html; charset=utf-8">
		<LINK href="<%=GroupSkin.getSkin(gd.getString("skin_code")).getPath()%>/css.css" type=text/css rel=stylesheet>
		<META content="MSHTML 6.00.2900.3132" name=GENERATOR>
	</HEAD>
	<BODY>
		<%@ include file="group_header.jsp"%>
		<DIV class="content xw">
			<%@ include file="group_left.jsp"%>
			<DIV class=rw>
<DIV class="admin block">
<DIV class=title>
<DIV class=cName>圈子活动&nbsp;</DIV>
</DIV>
<DIV class=txt id=memberList>
<DIV class=memberNote style="COLOR: #666">
  <DIV class=hackbox></DIV></DIV>
<TABLE class=topicList>
  <THEAD>
  <TR>
    <TH class=name style="WIDTH: 333px">标题</TH>
    <TH class=postPerson>发布者</TH>
    <TH class=count>回复/浏览</TH>
    <TH class=latest>最后回复</TH>
  </TR></THEAD>
  <TBODY>
<%
	int pagesize = 10;
	GroupActivityDb gad = new GroupActivityDb();
	String sql = gad.getListActivitySql(id);
    long total = gad.getQObjectCount(sql, "" + id);
	
	Paginator paginator = new Paginator(request, total, pagesize);
	int curpage = paginator.getCurPage();

	QObjectBlockIterator obi = gad.getQObjects(sql, "" + id,
			(curpage - 1) * pagesize, curpage * pagesize);
	UserDb user = null;
	MsgMgr mm = new MsgMgr();
	while (obi.hasNext()) {
		gad = (GroupActivityDb) obi.next();
		MsgDb md = mm.getMsgDb(gad.getLong("msg_id"));
		user = um.getUser(md.getName());
%>  
  <TR>
    <TD class=image style="WIDTH: 75px"><a href="../../<%=ForumPage.getShowTopicPage(request, md.getId())%>" target="_blank"><%=StrUtil.toHtml(md.getTitle())%></a></TD>
    <TD class=membername><a href="../../../userinfo.jsp?username=<%=StrUtil.UrlEncode(user.getName())%>"><%=user.getNick()%></a></TD>
    <TD class=sex style="WIDTH: 52px">
	<%=md.getRecount()%>/<%=md.getHit()%>
	</TD>
    <TD class=joinTime style="COLOR: #666">
	<%
				if (md.getRename().equals(""))
				out.print(user.getNick());
			else {
				out.print(um.getUser(md.getRename()).getNick());
			}
	%>
	<%=ForumSkin.formatDateTime(request, md.getRedate())%>
	</TD>
  </TR>
<%
}
%>	
</TBODY></TABLE>
<DIV class=more style="PADDING-BOTTOM: 5px">
<DIV id=AspNetPager1>
<%
	String querystr = "id=" + id;
	out.print(paginator.getPageBlock(request, "group_activity.jsp?"
			+ querystr));
%>
</DIV>
</DIV></DIV></DIV></DIV></DIV>
		<%@ include file="group_footer.jsp"%>
	</BODY>
</HTML>
