namespace decode64
{
    partial class Decode
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.richTextBox1 = new System.Windows.Forms.RichTextBox();
            this.richTextBox2 = new System.Windows.Forms.RichTextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.EnableAES = new System.Windows.Forms.CheckBox();
            this.Decrypt = new System.Windows.Forms.CheckBox();
            this.Keyword = new System.Windows.Forms.TextBox();
            this.kwl = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // richTextBox1
            // 
            this.richTextBox1.Location = new System.Drawing.Point(13, 13);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new System.Drawing.Size(420, 411);
            this.richTextBox1.TabIndex = 0;
            this.richTextBox1.Text = "";
            // 
            // richTextBox2
            // 
            this.richTextBox2.Location = new System.Drawing.Point(452, 12);
            this.richTextBox2.Name = "richTextBox2";
            this.richTextBox2.Size = new System.Drawing.Size(427, 412);
            this.richTextBox2.TabIndex = 1;
            this.richTextBox2.Text = "";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(452, 430);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(427, 51);
            this.button1.TabIndex = 2;
            this.button1.Text = "Just do it";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // EnableAES
            // 
            this.EnableAES.AutoSize = true;
            this.EnableAES.Location = new System.Drawing.Point(13, 430);
            this.EnableAES.Name = "EnableAES";
            this.EnableAES.Size = new System.Drawing.Size(47, 17);
            this.EnableAES.TabIndex = 3;
            this.EnableAES.Text = "AES";
            this.EnableAES.UseVisualStyleBackColor = true;
            // 
            // Decrypt
            // 
            this.Decrypt.AutoSize = true;
            this.Decrypt.Location = new System.Drawing.Point(13, 454);
            this.Decrypt.Name = "Decrypt";
            this.Decrypt.Size = new System.Drawing.Size(63, 17);
            this.Decrypt.TabIndex = 4;
            this.Decrypt.Text = "Decrypt";
            this.Decrypt.UseVisualStyleBackColor = true;
            // 
            // Keyword
            // 
            this.Keyword.Location = new System.Drawing.Point(81, 452);
            this.Keyword.Name = "Keyword";
            this.Keyword.Size = new System.Drawing.Size(351, 20);
            this.Keyword.TabIndex = 5;
            // 
            // kwl
            // 
            this.kwl.AutoSize = true;
            this.kwl.Location = new System.Drawing.Point(78, 431);
            this.kwl.Name = "kwl";
            this.kwl.Size = new System.Drawing.Size(93, 13);
            this.kwl.TabIndex = 6;
            this.kwl.Text = "AES KEYWORD :";
            // 
            // Decode
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(891, 493);
            this.Controls.Add(this.kwl);
            this.Controls.Add(this.Keyword);
            this.Controls.Add(this.Decrypt);
            this.Controls.Add(this.EnableAES);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.richTextBox2);
            this.Controls.Add(this.richTextBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "Decode";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RichTextBox richTextBox1;
        private System.Windows.Forms.RichTextBox richTextBox2;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.CheckBox EnableAES;
        private System.Windows.Forms.CheckBox Decrypt;
        private System.Windows.Forms.TextBox Keyword;
        private System.Windows.Forms.Label kwl;
    }
}

