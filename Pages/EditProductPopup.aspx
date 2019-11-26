<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditProductPopup.aspx.cs"
    Inherits="Pages_EditProductPopup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function OnConfirm() {
            $('#EditProductPopUp').dialog('close');
            fade_in();
            var productID = encodeURIComponent($('#productID').val());
            var productName = encodeURIComponent($('#productName').val());

            $('<div title="Подтверждение" id="Confirmation"/>').appendTo('body').load("/Pages/RemoveProductConfirmation.aspx?productID=" + productID + "&productName=" + productName).dialog({
                beforeClose: function (event, ui) {
                    fade_out();
                },
                show: { effect: 'fade', duration: 300 },
                hide: { effect: 'fade', duration: 300 },
                closeOnEscape: true,
                draggable: true,
                resizable: false,
                width: 400,
                height: 300,
                close: function (event, ui) {
                    $('#Confirmation').remove();
                },
                open: function () {
                }
            });
        }

        //Скрываем кнопки, если пользователь не аутентифицирован
        $(function () {
            
            var user_is_authentificated = getCookie("UserIsAuthentificated");
            
            if (user_is_authentificated != 'true') {
                //Закрываем поля для редактирования
                $('#RemoveProduct').hide();
                $('#SaveChangesBtn').hide();
                $("#productionArticlesTypes").prop("disabled", true);
                $("#productionArticlesGroups").prop("disabled", true);
                $("#productName").prop("disabled", true);
                $("#drawing").prop("disabled", true);
                $("#price").prop("disabled", true);
                $("#kod_skmtr").prop("disabled", true);
                $("#kod_okpd").prop("disabled", true);
            }
            var user_is_authorizated = getCookie("UserIsAuthorizated");
            if (user_is_authorizated) {
                //Закрываем доступ для редактирования поля, кроме СКМТР и ОКПД
                $('#RemoveProduct').hide();
                //$('#SaveChangesBtn').hide();
                $("#productionArticlesTypes").prop("disabled", true);
                $("#productionArticlesGroups").prop("disabled", true);
                $("#productName").prop("disabled", true);
                $("#drawing").prop("disabled", true);
                $("#price").prop("disabled", true);

                if (!$('#Button1').is(':visible')) {
                    //Открываем для редактирования поля кодов СКМТР и ОКПД
                    $("#kod_skmtr").prop("disabled", false);
                    $("#kod_okpd").prop("disabled", false);
                }
            }
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="productID" runat="server" />
        <table style="font-family: Verdana; font-size: 13px; text-align: left; top: 50px; margin-left: -13px;">
            <tr>
                <td class="tableFieldName">Тип:
                </td>
                <td style="font-size: 13px;">
                    <asp:DropDownList ID="productionArticlesTypes" runat="server" Width="422px" onchange="ChangeProductionType($('#productID').val());">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="tableFieldName">Группа:
                </td>
                <td style="font-size: 13px;">
                    <asp:DropDownList ID="productionArticlesGroups" runat="server" Width="422px">
                    </asp:DropDownList>
                </td>
            </tr>

            <tr>
                <td class="tableFieldName">Наименование:
                </td>
                <td style="font-size: 13px;">
                    <asp:TextBox ID="productName" runat="server" CssClass="CreateProductTextBox"></asp:TextBox>
                </td>
                <td style="color: Red;">
                    <asp:Label ID="productNameMessage" runat="server" Text="*"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tableFieldName">Чертёж/ГОСТ:
                </td>
                <td style="font-size: 13px;">
                    <asp:TextBox ID="drawing" runat="server" CssClass="CreateProductTextBox"></asp:TextBox>
                </td>
                <td style="color: Red;">
                    <asp:Label ID="drawingMessage" runat="server" Text="**"></asp:Label>
                </td>
            </tr>

            <tr>
                <td class="tableFieldName">Цена(руб.,коп.):
                </td>
                <td style="font-size: 13px;">
                    <asp:TextBox ID="price" runat="server" CssClass="CreateProductTextBox"></asp:TextBox>
                </td>
                <td style="color: Red;">
                    <asp:Label ID="priceMessage" runat="server" CssClass="CreateProductTextBox" Text="***"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>Код СКМТР:</td>
                <td>
                    <asp:TextBox ID="kod_skmtr" runat="server" Width="420px" MaxLength="15"></asp:TextBox>

                </td>
                <td></td>
            </tr>
            <tr>
                <td>Код ОКПД:</td>
                <td>
                    <asp:TextBox ID="kod_okpd" runat="server" Width="420px" MaxLength="15"></asp:TextBox>
                </td>
                <td></td>
            </tr>
        </table>
        <div class="border-580px" style="height: 2px; width: 582px; left: 0px; bottom: 40px; position: absolute; background-color: #507CD1;">
        </div>
        <div>
            <asp:Panel ID="btnPanel1" runat="server">
                <input type="button" class="button" value="Удалить изделие" id="RemoveProduct" onclick="OnConfirm();"
                    style="width: 140px; bottom: 1px; left: -4px; position: absolute; text-align: center; font-size: 13px;" />
                <input type="button" class="button" value="Сохранить" id="SaveChangesBtn" onclick="SaveChanges();"
                    style="width: 88px; bottom: 1px; right: 89px; position: absolute; text-align: center; font-size: 13px;" />
                <input type="button" class="button" value="Отмена" id="NoButton" onclick="close_dialog('#EditProductPopUp');"
                    style="width: 88px; text-align: center; position: absolute; bottom: 1px; right: -4px; font-size: 13px;" />
            </asp:Panel>
            <asp:Panel ID="btnPanel2" runat="server">
                <input type="button" class="button" value="OK" id="Button1" onclick="postBack();"
                    style="width: 90px; text-align: center; position: absolute; bottom: 1px; right: 235px; font-size: 13px;" />
                <div style="color: green; font-size: 13px; margin-left: 4px; margin-top: 10px;">
                    <asp:Label ID="SuccessMessage" runat="server" Text="Изделие успешно изменено"></asp:Label>
                </div>
            </asp:Panel>
            <div style="color: red; font-size: 13px; margin-left: 4px; margin-top: 10px;">
                <asp:Label ID="ErrorMessage1" runat="server" Text=""></asp:Label><br />
                <asp:Label ID="ErrorMessage2" runat="server" Text=""></asp:Label><br />
                <asp:Label ID="ErrorMessage3" runat="server" Text=""></asp:Label>
            </div>
        </div>
        <asp:HiddenField ID="windowMarker" runat="server" />
    </form>
</body>
</html>
