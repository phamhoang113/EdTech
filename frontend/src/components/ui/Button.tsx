import React from 'react';
import './Button.css';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
  isLoading?: boolean;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className = '', variant = 'primary', size = 'md', fullWidth, isLoading, children, ...props }, ref) => {
    const classes = [
      'btn',
      `btn-${variant}`,
      `btn-${size}`,
      fullWidth ? 'btn-full-width' : '',
      isLoading ? 'btn-loading' : '',
      className,
    ]
      .filter(Boolean)
      .join(' ');

    return (
      <button ref={ref} className={classes} disabled={isLoading || props.disabled} {...props}>
        {isLoading && <span className="spinner"></span>}
        <span className="btn-content">{children}</span>
      </button>
    );
  }
);

Button.displayName = 'Button';
