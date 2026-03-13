using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KumariCinemas.DAL;

namespace KumariCinemaSystem.Pages
{
    public partial class Dashboard : System.Web.UI.Page
    {
        public string MovieLabels = "[]";
        public string MovieSales = "[]";
        public string TimelineLabels = "[]";
        public string TimelineSales = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    // 1. Bar Chart Data (Sales by Movie)
                    DataTable dtMovies = DatabaseHelper.ExecuteQuery(@"
                        SELECT m.MovieTitle, COUNT(b.Booking_ID) as Sales
                        FROM Booking b
                        JOIN Show s ON b.Show_ID = s.Show_ID
                        JOIN Movie m ON s.Movie_ID = m.Movie_ID
                        GROUP BY m.MovieTitle
                        ORDER BY Sales DESC");

                    var mLabels = new System.Collections.Generic.List<string>();
                    var mSales = new System.Collections.Generic.List<string>();
                    foreach (DataRow row in dtMovies.Rows)
                    {
                        mLabels.Add("\"" + row["MovieTitle"].ToString() + "\"");
                        mSales.Add(row["Sales"].ToString());
                    }
                    if (mLabels.Count > 0)
                    {
                        MovieLabels = "[" + string.Join(",", mLabels) + "]";
                        MovieSales = "[" + string.Join(",", mSales) + "]";
                    }

                    // 2. Timeline Data (Daily Sales)
                    DataTable dtTimeline = DatabaseHelper.ExecuteQuery(@"
                        SELECT TO_CHAR(s.ShowDate, 'YYYY-MM-DD') as SaleDate, COUNT(b.Booking_ID) as Sales
                        FROM Booking b
                        JOIN Show s ON b.Show_ID = s.Show_ID
                        GROUP BY TO_CHAR(s.ShowDate, 'YYYY-MM-DD')
                        ORDER BY SaleDate ASC");

                    var tLabels = new System.Collections.Generic.List<string>();
                    var tSales = new System.Collections.Generic.List<string>();
                    foreach (DataRow row in dtTimeline.Rows)
                    {
                        tLabels.Add("\"" + row["SaleDate"].ToString() + "\"");
                        tSales.Add(row["Sales"].ToString());
                    }
                    if (tLabels.Count > 0)
                    {
                        TimelineLabels = "[" + string.Join(",", tLabels) + "]";
                        TimelineSales = "[" + string.Join(",", tSales) + "]";
                    }
                }
                catch (Exception)
                {
                    MovieLabels = "['No Data']"; MovieSales = "[0]";
                    TimelineLabels = "['No Data']"; TimelineSales = "[0]";
                }
            }
        }
    }
}