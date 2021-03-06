<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="cn.js.fan.util.*"%>
<%@page import="cn.js.fan.web.Global"%>
<%@page import="com.redmoon.oa.*"%>
<%@page import="com.redmoon.oa.message.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="com.cloudwebsoft.framework.db.JdbcTemplate"%>
<%@page import="cn.js.fan.db.ResultIterator"%>
<%@page import="cn.js.fan.db.ResultRecord"%>

<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="fsecurity" scope="page" class="cn.js.fan.security.SecurityUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<%
/*
- 功能描述：移动手机端使用
- 访问规则：手机端通知模块
- 过程描述：用于手机端通知模块附件的下载 
- 注意事项：
- 创建者：fgf 
- 创建时间：
*/
  JSONObject result = new JSONObject(); 
  String skey = ParamUtil.get(request,"skey");
  com.redmoon.oa.android.Privilege pri = new com.redmoon.oa.android.Privilege();
  String userName = pri.getUserName(skey);

  if(userName.equals("")){
	 try {
				result.put("res","-1");
				result.put("msg","skey不存在");
				out.println(result.toString());
				return;
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}

String priv = request.getParameter("priv");
if (priv==null)
	priv = "read";
if (!privilege.isUserPrivValid(request, priv))
{
	//response.setContentType("text/html;charset=gb2312"); 
	out.print("<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>");
	out.println(fchar.makeErrMsg("权限非法"));
	return;
}

int noticeId = StrUtil.toInt(ParamUtil.get(request, "noticeId"));

String sql = "select diskname,visualpath,name from oa_notice_attach where notice_id ="+ noticeId;
JdbcTemplate jd = new JdbcTemplate();
ResultIterator ri = jd.executeQuery(sql);
ResultRecord rr = null;
String diskName = "";
String path = "";
String name = "";
if(ri.hasNext()){
  rr = (ResultRecord)ri.next();
  diskName = rr.getString(1);
  path = rr.getString(2);
  name = rr.getString(3);
}



response.setContentType(MIMEMap.get(StrUtil.getFileExt(diskName)));
response.setHeader("Content-disposition","attachment; filename="+StrUtil.GBToUnicode(name));
String fullPath = Global.getRealPath()+"/"+ path+ diskName;



// response.setContentType("application/octet-stream");
// response.setHeader("Content-disposition","attachment; filename="+att.getName());

BufferedInputStream bis = null;
BufferedOutputStream bos = null;

try {
	bis = new BufferedInputStream(new FileInputStream(fullPath));
	bos = new BufferedOutputStream(response.getOutputStream());
	
	byte[] buff = new byte[2048];
	int bytesRead;
	
	while(-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
		bos.write(buff,0,bytesRead);
	}
} catch(final IOException e) {
	System.out.println( "IOException." + e );
} finally {
	if (bis != null)
		bis.close();
	if (bos != null)
		bos.close();
}
%>