import React from 'react';
import PropTypes from 'prop-types';
import MaidForm from './maidForm';

const maidNewComponent = ({ token }) => (
  <div>
    <h2>New maid</h2>
    <MaidForm token={token} action="/admin/maids" method="post" />
  </div>
);

maidNewComponent.propTypes = {
  token: PropTypes.string.isRequired,
};

export default maidNewComponent;
