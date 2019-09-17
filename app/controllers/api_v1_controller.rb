# frozen_string_literal: true

require 'httparty'

class ApiV1Controller < ApplicationController

  DEFAULT_HEADERS = headers = {
    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    'Accept': 'application/json'
  }.freeze

  # TESTS the `POST /oauth/token` endpoint
  def auth_test
    if params[:client_uid].blank? || params[:client_secret].blank?
      json = { 'errors': 'Please provide both a UID and Secret!' }
    else
      args = {
        grant_type: 'client_credentials',
        client_id: params[:client_uid].to_s,
        client_secret: params[:client_secret].to_s
      }
      begin
        resp = HTTParty.post('http://localhost:3000/oauth/token', body: args, headers: DEFAULT_HEADERS)
        payload = JSON.parse(resp.body)
        json = { 'token': payload } if resp.code == 200
        json = { 'errors': "#{payload['error']} - #{payload['error_description']}" } unless resp.code == 200

      rescue StandardError => se
        json = { 'errors': se.message }
      end
    end
    render json: JSON.pretty_generate(json), callback: 'displayAuthTestResults'
  end

  # TESTS the `GET /data_management_plans` endpoint
  def dmps_test
    if params[:token].blank?
      json = { 'errors': 'You must generate a token first!' }
    else
      begin
        hdrs = DEFAULT_HEADERS.merge({ 'Authorization': "Bearer #{params[:token]}" })
        resp = HTTParty.get('http://localhost:3000/api/v1/data_management_plans', headers: hdrs)
        payload = JSON.parse(resp.body)
        json = { 'dmps': payload } if resp.code == 200
        json = { 'errors': "#{payload['error']} - #{payload['error_description']}" } unless resp.code == 200

      rescue StandardError => se
        json = { 'errors': se.message }
      end
    end
    render json: JSON.pretty_generate(json), callback: 'displayIndexTestResults'
  end

  # TESTS the `GET /data_management_plan/:id` endpoint
  def dmp_test
    if params[:token].blank?
      json = { 'errors': 'You must generate a token first!' }
    elsif params[:doi].blank?
      json = { 'errors': 'You must specifiy a DMP DOI!' }
    else
      begin
        hdrs = DEFAULT_HEADERS.merge({ 'Authorization': "Bearer #{params[:token]}" })
        resp = HTTParty.get("http://localhost:3000/api/v1/data_management_plans/#{params[:doi]}", headers: hdrs)
        payload = JSON.parse(resp.body)
        json = { 'dmps': payload } if resp.code == 200
        json = { 'errors': "#{payload['error']} - #{payload['error_description']}" } unless resp.code == 200

      rescue StandardError => se
        json = { 'errors': se.message }
      end
    end
    render json: JSON.pretty_generate(json), callback: 'displayShowTestResults'
  end

  # TESTS the `POST /data_management_plans` endpoint
  def dmp_create_minimal_test
    if params[:token].blank?
      json = { 'errors': 'You must generate a token first!' }
    elsif params[:title].blank? || params[:contact_name].blank? || params[:contact_email].blank? ||
          params[:contact_id].blank?
      json = { 'errors': 'You must complete each field!' }
    else
      begin
        args = {
          dmp: {
            title: params[:title],
            language: 'en',
            contact: {
              mbox: params[:contact_email],
              name: params[:contact_name],
              contact_ids: [{
                value: params[:contact_id],
                category: "orcid"
              }]
            }
          }
        }

        hdrs = DEFAULT_HEADERS.merge({ 'Authorization': "Bearer #{params[:token]}" })
        resp = HTTParty.post('http://localhost:3000/api/v1/data_management_plans', body: args, headers: hdrs)
        payload = JSON.parse(resp.body)
        json = { 'dmp': payload } if resp.code == 201
        json = { 'errors': "#{payload['error']} - #{payload['error_description']}" } unless resp.code == 201

      rescue StandardError => se
        json = { 'errors': se.message }
      end
    end
    render json: JSON.pretty_generate(json), callback: 'displayCreateMinimalTestResults'
  end

  # TESTS the `POST /data_management_plans` endpoint
  def dmp_create_test
    if params[:token].blank?
      json = { 'errors': 'You must generate a token first!' }
    elsif params[:json].blank?
      json = { 'errors': 'You must provide JSON data' }
    else
      begin
        input = JSON.parse(params.fetch(:json, {}))
        hdrs = DEFAULT_HEADERS.merge({ 'Authorization': "Bearer #{params[:token]}" })
        resp = HTTParty.post('http://localhost:3000/api/v1/data_management_plans', body: input, headers: hdrs)
        payload = JSON.parse(resp.body)
        json = { 'dmp': payload } if resp.code == 201
        json = { 'errors': "#{payload['error']} - #{payload['error_description']}" } unless resp.code == 201

      rescue StandardError => se
        json = { 'errors': se.message }
      end
    end
    render json: JSON.pretty_generate(json), callback: 'displayCreateTestResults'
  end
end
