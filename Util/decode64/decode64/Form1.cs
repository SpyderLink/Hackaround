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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            byte[] decbuff = Convert.FromBase64String(richTextBox1.Text);
            richTextBox2.Text = System.Text.Encoding.UTF8.GetString(decbuff);
        }
    }
}
