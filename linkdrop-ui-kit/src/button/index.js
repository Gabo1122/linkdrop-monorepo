import React from 'react'
import classNames from 'classnames'
import styles from './styles.module'
import PropTypes from 'prop-types'

class Button extends React.Component {
  render () {
    const { disabled, children, inverted, onClick, className, size = 'normal', loading } = this.props
    return <button
      onClick={_ => onClick && onClick()}
      disabled={disabled}
      className={classNames(styles.container, className, styles[`${size}Size`], {
        [styles.disabled]: disabled,
        [styles.inverted]: inverted || loading
      })}
    >
      {loading ? <div className={styles.loading}><div /><div /><div /><div /></div> : children}
    </button>
  }
}

Button.propTypes = {
  disabled: PropTypes.bool,
  inverted: PropTypes.bool,
  children: PropTypes.any,
  onClick: PropTypes.func,
  loading: PropTypes.bool
}

export default Button