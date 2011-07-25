using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace decode64
{
    public partial class Decode : Form
    {
        public Decode()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (EnableAES.Checked)
            {
                if (Decrypt.Checked)
                {
                    richTextBox2.Text = AES.Crypto.DecryptStringAES(richTextBox1.Text, Keyword.Text);
                }
                else
                {
                    richTextBox2.Text = AES.Crypto.EncryptStringAES(richTextBox1.Text, Keyword.Text);
                }
            }
            else
            {
                if (Decrypt.Checked)
                {
                    byte[] decbuff = Convert.FromBase64String(richTextBox1.Text);
                    richTextBox2.Text = System.Text.Encoding.UTF8.GetString(decbuff);
                }
                else
                {
                    byte[] encbuff = System.Text.Encoding.UTF8.GetBytes(richTextBox1.Text);
                    richTextBox2.Text = Convert.ToBase64String(encbuff);
                }
            }
        }
    }
}
