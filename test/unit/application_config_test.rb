# frozen_string_literal: true

require 'test_helper'

class ApplicationConfigTest < ActiveSupport::TestCase
  def test_cve_2022_32224_safe_permitted_classes
    assert_nil Rails.application.config.active_record.yaml_column_permitted_classes,
               "Rails.application.config.active_record.yaml_column_permitted_classes has changed. \
               Please determine whether it is CVE-2022-32224 safe."
  end

  def test_cve_2022_32224_no_use_yaml_unsafe_load
    assert_nil Rails.application.config.active_record.use_yaml_unsafe_load,
               "Rails.application.config.active_record.use_yaml_unsafe_load is CVE-2022-32224 unsafe."
  end
end
