using System;
using System.Net.Mail;


namespace DB_Lab3
{
    public class StoredProcedures
    {
        public static void SendEmailUsingCLR(string receiver)
        {
            string _sender = "premiumkinobot@gmail.com";
            string _password = "ibxprcrkbhsprkxg";
            SmtpClient client = new SmtpClient("smtp.gmail.com");
            client.Port = 587;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            System.Net.NetworkCredential credentials =
                 new System.Net.NetworkCredential(_sender, _password);
            client.EnableSsl = true;
            client.Credentials = credentials;
            try
            {
                var mail = new MailMessage(_sender, receiver);
                mail.Subject = "Lab 3";
                mail.Body = "This email sent using CLR Assembly";
                client.Send(mail);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw ex;
            }
        }
    }
}

