using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_AddUser : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadUsers();
        }
        else
        {
            LoadUsers();
        }
    }

    private void LoadUsers()
    {
        MainDataClassesDataContext dataContext = new MainDataClassesDataContext();
        List<ogk_GetUsersResult> list = dataContext.ogk_GetUsers().ToList();

        //Формируем вид таблицы для последующего заполнения
        DataTable dt = new DataTable();
        dt.Columns.Add("ID");
        dt.Columns.Add("USER_NAME");
        dt.Columns.Add("ACCESS");

        int i = 1;
        //Заполняем таблицу данными из запроса
        foreach (var item in list)
        {
            string access;
            if (item.EDIT_SKMTR_OKPD_ONLY == 0)
	        {
                access = "Полный доступ";
	        }
            else
            {
                access = "Редактирование кодов";
            }
            
            dt.Rows.Add(item.ID, item.NAME, access);

            i ++;
        }

        UsersGridView.DataSource = dt;
        UsersGridView.DataBind();
    }

    /// <summary>
    /// Создает пароль длиной n символов
    /// </summary>
    /// <param name="passwordLength">Длина пароля</param>
    /// <returns></returns>
    public string GetPassword(int passwordLength)
    {
        StringBuilder sb = new StringBuilder();
        var r = new Random();
        while (sb.Length < passwordLength)
        {
            Char c = (char)r.Next(33, 125);
            if (Char.IsLetterOrDigit(c))
                sb.Append(c);
        }
        return sb.ToString();
    }
    
    
    protected void UsersGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
    }

    protected void UsersGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        e.Row.Cells[0].Attributes.Add("style", "visibility: hidden;");
    }

    protected void CreateUserBtn_Click(object sender, EventArgs e)
    {
        //Шаблон нескольких пробелов подряд
        Regex r = new Regex(@"\s+");
        //Заменяем несколько пробелов одним
        string userName = r.Replace(UserName.Text, @" ");

        string userPassword = r.Replace(UserPassword.Text, @" ");
        
        //Обрезаем пробелы по концам 
        userName = userName.Trim();
        userPassword = userPassword.Trim();

        if (UserNameCheck(userName)&&UserPasswordCheck(userPassword))
        {
            MessageLabel.Text = CreateUser(userName, EDIT_SKMTR_OKPD_ONLY.Checked);
            LoadUsers();
        }
    }

    private bool UserNameCheck(string userName)
    {
        if (userName.Length == 0)
        {
            MessageLabel.ForeColor = System.Drawing.Color.Red;
            MessageLabel.Text = "Имя пользователя должно быть непустым";
            return false;
        }
        else if (UserIsAlreadyExists(userName))
        {

            MessageLabel.ForeColor = System.Drawing.Color.Red;
            MessageLabel.Text = "Пользователь с таким именем уже существует";
            return false;
        }
        else if (userName == "Логин")
        {
            MessageLabel.ForeColor = System.Drawing.Color.Red;
            MessageLabel.Text = "Невозможно создать пользователя с именем \"Логин\"";
            return false;
        }
            else
	    {
            return true;
	    }
        
    }

    private bool UserPasswordCheck(string userPassword)
    {
        if (userPassword.Length == 0)
        {
            MessageLabel.ForeColor = System.Drawing.Color.Red;
            MessageLabel.Text = "Пароль пользователя должен быть непустым";
            return false;
        }

        else if (userPassword == "Пароль")
        {
            MessageLabel.ForeColor = System.Drawing.Color.Red;
            MessageLabel.Text = "Невозможно создать пользователя с паролем \"Пароль\"";
            return false;
        }
        else
        {
            return true;
        }

    }



    /// <summary>
    /// Проверяет существование пользователя с таким же именем
    /// </summary>
    /// <param name="userName">Имя пользователя</param>
    /// <returns></returns>
    private bool UserIsAlreadyExists(string userName)
    {
        for (int i = 0; i < UsersGridView.Rows.Count; i++)
        {
            if (UsersGridView.Rows[i].Cells[1].Text == userName)
            {
                return true;
            }
        }
        return false;
    }


    /// <summary>
    /// Создает пользователя с именем и сгенерированным паролем
    /// </summary>
    /// <param name="userName">Имя пользователя</param>
    private string CreateUser(string userName, bool edit_skmtr_okpd_only)
    {
        try
        {
            string password = UserPassword.Text;

            //Шифруем пароль
            string encryptedPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(password, "SHA1");

            MainDataClassesDataContext dc = new MainDataClassesDataContext();
            dc.ogk_CreateUser(userName, encryptedPassword, Convert.ToInt32(edit_skmtr_okpd_only));
            UserName.Text = "Логин";
            UserPassword.Text = "Пароль";

            MessageLabel.ForeColor = System.Drawing.Color.Green;
            return "Создан пользователь " + userName + " с паролем " + password;
        }
        catch (Exception)
        {
            MessageLabel.ForeColor = System.Drawing.Color.Red;
            return "Невозможно создать пользователя";
        }
    }

    public void UsersGridView_OnRowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            MainDataClassesDataContext dc = new MainDataClassesDataContext();
            dc.ogk_DeleteUser(Convert.ToInt32(UsersGridView.Rows[e.RowIndex].Cells[0].Text));
            LoadUsers();
            UserName.Text = "Логин";
            UserPassword.Text = "Пароль";
            MessageLabel.Text = String.Empty;
        }
        catch (Exception)
        {
            MessageLabel.Text = "Удаление пользователя " + UsersGridView.Rows[e.RowIndex].Cells[1].Text + " не удалось";
        }
    }

    public void UsersGridView_OnRowEditing(object sender, GridViewEditEventArgs e)
    {
        MessageLabel.Text = "Редактируем строку " + e.NewEditIndex;
    }
}