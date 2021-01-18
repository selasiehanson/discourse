# frozen_string_literal: true

class Admin::DashboardController < Admin::AdminController
  def index
    data = AdminDashboardIndexData.fetch_cached_stats

    if SiteSetting.version_checks?
      data.merge!(version_check: DiscourseUpdates.check_version.as_json)
    end

    new_features = DiscourseUpdates.unseen_new_features current_user.id
    data.merge!(new_features: new_features.as_json)
    data.merge!(release_notes_link: AdminDashboardGeneralData.fetch_cached_stats["release_notes_link"])

    render json: data
  end

  def moderation; end
  def security; end
  def reports; end

  def general
    render json: AdminDashboardGeneralData.fetch_cached_stats
  end

  def problems
    render_json_dump(problems: AdminDashboardData.fetch_problems(check_force_https: request.ssl?))
  end

  def mark_new_features_as_seen
    render json: DiscourseUpdates.mark_new_features_as_seen(current_user.id)
  end
end
