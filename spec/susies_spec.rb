# rspec
require 'rspec/autorun'
require File.expand_path "../../lib/susies", __FILE__

# helpers
require File.expand_path '../helpers/init', __FILE__
include SusiesHelper

describe Susies do

  # Intance Variables after init
  describe 'Instance variables' do
    # With default params
    context 'with default params' do
      let(:susies) { Susies.new }

      it 'should set good values' do
        expect( susies.instance_variable_get :@login        ).to eq Susies::DEFAULT_LOGIN
        expect( susies.instance_variable_get :@maxStudent   ).to eq Susies::DEFAULT_MAX_STUDENT
        expect( susies.instance_variable_get :@autologinURL ).to eq Susies::DEFAULT_AUTOLOGIN_URL
        expect( susies.instance_variable_get :@mailServer   ).to eq Susies::DEFAULT_MAIL_SERVER
        expect( susies.instance_variable_get :@mailPort     ).to eq Susies::DEFAULT_MAIL_PORT
        expect( susies.instance_variable_get :@mailUname    ).to eq Susies::DEFAULT_MAIL_UNAME
        expect( susies.instance_variable_get :@mailPasswd   ).to eq Susies::DEFAULT_MAIL_PASSWD
        expect( susies.instance_variable_get :@mailTargets  ).to eq [Susies::DEFAULT_MAIL_UNAME]
        expect( susies.instance_variable_get :@startWeek    ).to eq Susies::DEFAULT_START_WEEK
        expect( susies.instance_variable_get :@endWeek      ).to eq Susies::DEFAULT_END_WEEK
      end
    end

    # With defined params
    context 'with defined params' do
      let(:data)   { SusiesHelper::definedParams }
      let(:susies) { Susies.new data }

      it 'should set good values' do
        expect( susies.instance_variable_get :@login        ).to eq data[:login]
        expect( susies.instance_variable_get :@maxStudent   ).to eq data[:maxStudent]
        expect( susies.instance_variable_get :@autologinURL ).to eq data[:autologinURL]
        expect( susies.instance_variable_get :@mailServer   ).to eq data[:mailServer]
        expect( susies.instance_variable_get :@mailPort     ).to eq data[:mailPort]
        expect( susies.instance_variable_get :@mailUname    ).to eq data[:mailUname]
        expect( susies.instance_variable_get :@mailPasswd   ).to eq data[:mailPasswd]
        expect( susies.instance_variable_get :@mailTargets  ).to eq data[:mailTargets]
        expect( susies.instance_variable_get :@startWeek    ).to eq Susies::DEFAULT_START_WEEK
        expect( susies.instance_variable_get :@endWeek      ).to eq Susies::DEFAULT_END_WEEK
      end
    end
  end

end
