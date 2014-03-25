require 'spec_helper'

describe Recipe do
  it { should have_one :search_content }
end
