<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs"
    Inherits="KumariCinemaSystem.Pages.Dashboard" MasterPageFile="~/Site.Master" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <style>
            .dashboard-card {
                background: rgba(30, 41, 59, 0.7);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 12px;
                padding: 2.5rem 1.5rem;
                text-align: center;
                transition: all 0.3s ease;
                text-decoration: none;
                color: var(--text-main);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100%;
            }

            .dashboard-card:hover {
                transform: translateY(-5px);
                background: rgba(99, 102, 241, 0.15);
                border-color: var(--primary);
                color: white;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            }

            .dashboard-icon {
                font-size: 3rem;
                color: var(--primary);
                margin-bottom: 1rem;
                transition: color 0.3s;
            }

            .dashboard-card:hover .dashboard-icon {
                color: var(--secondary);
            }

            .dashboard-title {
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .dashboard-subtitle {
                font-size: 0.875rem;
                color: #94a3b8;
            }

            .section-title {
                color: var(--primary);
                border-bottom: 2px solid rgba(255, 255, 255, 0.1);
                padding-bottom: 10px;
                margin-bottom: 20px;
                margin-top: 40px;
            }
        </style>

        <div class="text-center mb-5">
            <h1 class="display-4 fw-bold" style="color: white;">Kumari <span
                    style="color: var(--primary);">Cinemas</span></h1>
            <p class="lead" style="color: #94a3b8;">Centralized Ticket Management System Dashboard</p>
        </div>

        <!-- Analytics Graph Section -->
        <div class="row mb-5 g-4">
            <!-- 1. Top Movie Sales -->
            <div class="col-lg-6">
                <div class="card h-100"
                    style="background: rgba(30, 41, 59, 0.7); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 12px;">
                    <div class="card-header bg-transparent border-bottom border-secondary py-3">
                        <h5 class="m-0 text-info"><i class="fas fa-chart-bar me-2"></i> Top Movie Sales</h5>
                    </div>
                    <div class="card-body p-4" style="min-height: 350px;">
                        <canvas id="movieChart"></canvas>
                    </div>
                </div>
            </div>
            <!-- 2. Sales Timeline -->
            <div class="col-lg-6">
                <div class="card h-100"
                    style="background: rgba(30, 41, 59, 0.7); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 12px;">
                    <div class="card-header bg-transparent border-bottom border-secondary py-3">
                        <h5 class="m-0 text-primary"><i class="fas fa-chart-line me-2"></i> Sales Timeline</h5>
                    </div>
                    <div class="card-body p-4" style="min-height: 350px;">
                        <canvas id="timelineChart"></canvas>
                    </div>
                </div>
            </div>
            <!-- 3. Sales by Genre -->
            <div class="col-lg-6">
                <div class="card h-100"
                    style="background: rgba(30, 41, 59, 0.7); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 12px;">
                    <div class="card-header bg-transparent border-bottom border-secondary py-3">
                        <h5 class="m-0 text-warning"><i class="fas fa-chart-pie me-2"></i> Ticket Sales by Genre</h5>
                    </div>
                    <div class="card-body p-4 d-flex justify-content-center align-items-center" style="min-height: 350px;">
                        <canvas id="genreChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>
            </div>
            <!-- 4. Revenue by Theater -->
            <div class="col-lg-6">
                <div class="card h-100"
                    style="background: rgba(30, 41, 59, 0.7); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 12px;">
                    <div class="card-header bg-transparent border-bottom border-secondary py-3">
                        <h5 class="m-0 text-success"><i class="fas fa-hand-holding-usd me-2"></i> Revenue by Theater</h5>
                    </div>
                    <div class="card-body p-4 d-flex justify-content-center align-items-center" style="min-height: 350px;">
                        <canvas id="theaterChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chart.js Library -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // 1. Movie Bar Chart
                const movieCtx = document.getElementById('movieChart').getContext('2d');
                new Chart(movieCtx, {
                    type: 'bar',
                    data: {
                        labels: <%= MovieLabels %>,
                    datasets: [{
                        label: 'Tickets',
                        data: <%= MovieSales %>,
                        backgroundColor: 'rgba(99, 102, 241, 0.6)',
                        borderColor: '#6366f1',
                        borderWidth: 1,
                        borderRadius: 5
                        }]
                    },
                options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#94a3b8' } },
                    x: { grid: { display: false }, ticks: { color: '#94a3b8' } }
                }
            }
                });

            // 2. Sales Timeline Line Chart
            const timelineCtx = document.getElementById('timelineChart').getContext('2d');
            new Chart(timelineCtx, {
                type: 'line',
                data: {
                    labels: <%= TimelineLabels %>,
                datasets: [{
                    label: 'Daily Sales',
                    data: <%= TimelineSales %>,
                    borderColor: '#ec4899',
                    backgroundColor: 'rgba(236, 72, 153, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointBackgroundColor: '#ec4899'
                        }]
                    },
                options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#94a3b8' } },
                    x: { grid: { display: false }, ticks: { color: '#94a3b8' } }
                }
            }
                });

            // 3. Sales by Genre Pie Chart
            const genreCtx = document.getElementById('genreChart').getContext('2d');
            new Chart(genreCtx, {
                type: 'pie',
                data: {
                    labels: <%= GenreLabels %>,
                    datasets: [{
                        data: <%= GenreSales %>,
                        backgroundColor: [
                            'rgba(99, 102, 241, 0.8)',
                            'rgba(236, 72, 153, 0.8)',
                            'rgba(16, 185, 129, 0.8)',
                            'rgba(245, 158, 11, 0.8)',
                            'rgba(56, 189, 248, 0.8)'
                        ],
                        borderWidth: 1,
                        borderColor: '#0f172a'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'right', labels: { color: '#e2e8f0' } }
                    }
                }
            });

            // 4. Revenue by Theater Doughnut Chart
            const theaterCtx = document.getElementById('theaterChart').getContext('2d');
            new Chart(theaterCtx, {
                type: 'doughnut',
                data: {
                    labels: <%= TheaterLabels %>,
                    datasets: [{
                        data: <%= TheaterRevenue %>,
                        backgroundColor: [
                            'rgba(16, 185, 129, 0.8)',
                            'rgba(56, 189, 248, 0.8)',
                            'rgba(168, 85, 247, 0.8)',
                            'rgba(239, 68, 68, 0.8)'
                        ],
                        borderWidth: 1,
                        borderColor: '#0f172a'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '65%',
                    plugins: {
                        legend: { position: 'right', labels: { color: '#e2e8f0' } }
                    }
                }
            });
            });
        </script>

        <!-- Basic Management Section -->
        <h3 class="section-title"><i class="fas fa-cogs me-2"></i> Basic Management (CRUD)</h3>
        <div class="row g-4">
            <div class="col-md-4 col-lg-3">
                <a runat="server" href="~/Pages/Users.aspx" class="dashboard-card">
                    <i class="fas fa-users dashboard-icon"></i>
                    <div class="dashboard-title">Users</div>
                    <div class="dashboard-subtitle">Manage customer accounts</div>
                </a>
            </div>
            <div class="col-md-4 col-lg-3">
                <a runat="server" href="~/Pages/Movies.aspx" class="dashboard-card">
                    <i class="fas fa-film dashboard-icon"></i>
                    <div class="dashboard-title">Movies</div>
                    <div class="dashboard-subtitle">Manage movie details</div>
                </a>
            </div>
            <div class="col-md-4 col-lg-3">
                <a runat="server" href="~/Pages/TheatreCityHall.aspx" class="dashboard-card">
                    <i class="fas fa-building dashboard-icon"></i>
                    <div class="dashboard-title">Theaters & Halls</div>
                    <div class="dashboard-subtitle">Manage venues and capacities</div>
                </a>
            </div>
            <div class="col-md-4 col-lg-3">
                <a runat="server" href="~/Pages/ShowTimes.aspx" class="dashboard-card">
                    <i class="fas fa-calendar-alt dashboard-icon"></i>
                    <div class="dashboard-title">Showtimes</div>
                    <div class="dashboard-subtitle">Schedule movie screenings</div>
                </a>
            </div>
            <div class="col-md-4 col-lg-3">
                <a runat="server" href="~/Pages/Booking.aspx" class="dashboard-card">
                    <i class="fas fa-ticket-alt dashboard-icon"></i>
                    <div class="dashboard-title">Bookings</div>
                    <div class="dashboard-subtitle">Manage ticket orders</div>
                </a>
            </div>
        </div>

        <!-- Complex Reports Section -->
        <h3 class="section-title"><i class="fas fa-chart-pie me-2"></i> Complex Reports & Analytics</h3>
        <div class="row g-4">
            <div class="col-md-4">
                <a runat="server" href="~/Pages/UserTickets.aspx" class="dashboard-card">
                    <i class="fas fa-history dashboard-icon"></i>
                    <div class="dashboard-title">User Ticket History</div>
                    <div class="dashboard-subtitle">View 6-month ticket history for any user</div>
                </a>
            </div>
            <div class="col-md-4">
                <a runat="server" href="~/Pages/TheaterMovies.aspx" class="dashboard-card">
                    <i class="fas fa-video dashboard-icon"></i>
                    <div class="dashboard-title">Theater Movies</div>
                    <div class="dashboard-subtitle">View active schedule for a specific hall</div>
                </a>
            </div>
            <div class="col-md-4">
                <a runat="server" href="~/Pages/Occupancy.aspx" class="dashboard-card">
                    <i class="fas fa-percentage dashboard-icon"></i>
                    <div class="dashboard-title">Occupancy Report</div>
                    <div class="dashboard-subtitle">Top 3 performing halls for a specific movie</div>
                </a>
            </div>
        </div>
    </asp:Content>