import React from 'react';
import { shallow } from 'enzyme';
import WaitlistNewComponent from '../waitlistNew';

describe('First React component test with Enzyme', () => {
  it('renders without crashing', () => {
    shallow(<WaitlistNewComponent />);
  });
});
