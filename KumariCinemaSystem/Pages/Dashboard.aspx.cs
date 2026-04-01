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
        public string GenreLabels = "[]";
        public string GenreSales = "[]";
        public string TheaterLabels = "[]";
        public string TheaterRevenue = "[]";

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
                    // 3. Genre Data (Sales by Genre)
                    DataTable dtGenre = DatabaseHelper.ExecuteQuery(@"
                        SELECT m.Genre, COUNT(b.Booking_ID) as Sales
                        FROM Booking b
                        JOIN Show s ON b.Show_ID = s.Show_ID
                        JOIN Movie m ON s.Movie_ID = m.Movie_ID
                        GROUP BY m.Genre");

                    var gLabels = new System.Collections.Generic.List<string>();
                    var gSales = new System.Collections.Generic.List<string>();
                    foreach (DataRow row in dtGenre.Rows)
                    {
                        string genre = row["Genre"].ToString();
                        gLabels.Add("\"" + (string.IsNullOrEmpty(genre) ? "Unknown" : genre) + "\"");
                        gSales.Add(row["Sales"].ToString());
                    }
                    if (gLabels.Count > 0)
                    {
                        GenreLabels = "[" + string.Join(",", gLabels) + "]";
                        GenreSales = "[" + string.Join(",", gSales) + "]";
                    }

                    // 4. Theater Revenue Data
                    DataTable dtTheater = DatabaseHelper.ExecuteQuery(@"
                        SELECT t.TheatreName, SUM(s.TicketPrice) as Revenue
                        FROM Booking b
                        JOIN Show s ON b.Show_ID = s.Show_ID
                        JOIN Hall h ON s.Hall_ID = h.Hall_ID
                        JOIN Theatre t ON h.Theatre_ID = t.Theatre_ID
                        GROUP BY t.TheatreName");

                    var thLabels = new System.Collections.Generic.List<string>();
                    var thRevenue = new System.Collections.Generic.List<string>();
                    foreach (DataRow row in dtTheater.Rows)
                    {
                        thLabels.Add("\"" + row["TheatreName"].ToString() + "\"");
                        thRevenue.Add(row["Revenue"].ToString());
                    }
                    if (thLabels.Count > 0)
                    {
                        TheaterLabels = "[" + string.Join(",", thLabels) + "]";
                        TheaterRevenue = "[" + string.Join(",", thRevenue) + "]";
                    }
                }
                catch (Exception)
                {
                    MovieLabels = "['No Data']"; MovieSales = "[0]";
                    TimelineLabels = "['No Data']"; TimelineSales = "[0]";
                    GenreLabels = "['No Data']"; GenreSales = "[0]";
                    TheaterLabels = "['No Data']"; TheaterRevenue = "[0]";
                }
            }
        }
    }
}