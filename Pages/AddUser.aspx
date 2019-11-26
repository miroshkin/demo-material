<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddUser.aspx.cs" Inherits="Pages_AddUser" %>

<%@ Register Src="../UserControls/header.ascx" TagName="header" TagPrefix="uc2" %>
<%@ Register Src="../UserControls/footer.ascx" TagName="footer" TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>РЕДАКТОР ПОЛЬЗОВАТЕЛЕЙ</title>
    <script src="../Scripts/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="../Scripts/app.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui.min.js" type="text/javascript"></script>
    <link href="../Styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/jquery-ui.structure.min.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/Main.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function myfunction() {
            alert("Eeeee!");
            _doPostBack('UpdatePassword', '');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="header" class="header">
            <uc2:header ID="header1" runat="server" />
        </div>
        <div class="sectionName">
            РЕДАКТОР ПОЛЬЗОВАТЕЛЕЙ
        </div>
        <div style="position: absolute; top: 60px; left: 20px; font-family: Verdana; font-size: 13px;">
            <h1>Пользователи</h1>

            <asp:GridView ID="UsersGridView" runat="server" ShowHeader="False"
                GridLines="None" OnRowDataBound="UsersGridView_RowDataBound" AutoGenerateColumns="False" OnRowDeleting="UsersGridView_OnRowDeleting" 
                OnRowEditing="UsersGridView_OnRowEditing" >
                <Columns>
                    <asp:BoundField DataField="ID" />
                    <asp:BoundField DataField="USER_NAME" ShowHeader="False" ItemStyle-Width="200px">
                        <ItemStyle Width="150px"></ItemStyle>
                    </asp:BoundField>
                   
                    <%--<asp:CheckBoxField DataField="EDIT_SKMTR_OKPD_ONLY" />--%>
                   
                    <asp:BoundField DataField="ACCESS" >
                   
                    <ItemStyle Width="190px" />
                    </asp:BoundField>
                   
                    <asp:CommandField ShowDeleteButton="True" DeleteText="Удалить"/>
                   
                </Columns>
            </asp:GridView>
            <br />
            <h1>Создать пользователя</h1>

            <div style="left:16px;position:relative;">
                <asp:TextBox ID="UserName" runat="server" Text="Логин"></asp:TextBox>
                <asp:TextBox ID="UserPassword" runat="server" Text="Пароль"></asp:TextBox>

            <asp:CheckBox ID="EDIT_SKMTR_OKPD_ONLY" runat="server" Text="Только коды СКМТР и ОКПД"/>
            <asp:Button ID="CreateUserBtn" runat="server" Text="Создать" OnClick="CreateUserBtn_Click" CssClass="button" Width="69px" Height="24px"/>
            <br />
            <br />
            <asp:Label ID="MessageLabel" runat="server"></asp:Label>
            </div>
            


        </div>

        <div id="footer" class="footer">
            <uc1:footer ID="footer1" runat="server" />
        </div>
    </form>
</body>
</html>
