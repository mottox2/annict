# frozen_string_literal: true

class CalendarsController < ApplicationController
  def show(username)
    @user = User.find_by!(username: username)
    I18n.locale = @user.locale

    @programs = @user.
      programs.
      unwatched_all.
      work_published.
      episode_published.
      where("started_at >= ?", Date.today.beginning_of_day).
      where("started_at <= ?", 7.days.since.end_of_day)
    @works = @user.
      works.
      wanna_watch_and_watching.
      where.not(started_on: nil).
      where("started_on >= ?", Date.today.beginning_of_day).
      where("started_on <= ?", 7.days.since.end_of_day)

    respond_to do |format|
      format.ics
    end
  end
end