require 'holiday_japan'

class AttendancesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    year = params[:year].to_i
    month = params[:month].to_i

    @holidays = Attendance.getHolidays(year, month)
    @days = Attendance.getCalender(year, month)

    if year == 0 || month == 0
      current_time = Time.now
      year = current_time.year
      month = current_time.month
    end

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    @attendances = Attendance.where(user_id: params[:user_id]).where(attendance_date: start_date..end_date)
  end

  def new
    lastAttendance = Attendance.where(user_id: params[:user_id], attendance_date: Date.today).order(attendance_date: :desc).first
    if lastAttendance.nil?
      @lastAttendance = @user.attendances.new
    else
      @lastAttendance = lastAttendance
    end
    @user = User.find(params[:user_id])
  end

  def create
    @Attendance = Attendance.new(
      attendance_date: Date.today,
      attendance_starttime: Time.now,
      attendance_endtime: nil,
      user_id: params[:user_id]
    )

    if @Attendance.check_today_data
      flash[:alert] = "今日のデータはすでに存在します。"
      redirect_to user_attendances_path
    else
      if @Attendance.save
        redirect_to user_attendances_path
      else
        flash[:error] = "Failed to create attendance."
        redirect_to user_attendances_path
      end
    end

  end

  def update
    @attendance = Attendance.find(params[:id])
    @attendance.attendance_endtime = Time.now

    if @attendance.save
        redirect_to user_attendances_path
    else
        redirect_to user_attendances_path
    end
end

  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインが必要です"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless @user == current_user
    end

end
